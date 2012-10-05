require "spec_helper"

module GDash
  describe Ganglia do
    let :ganglia do
      described_class.new do |ganglia|
        ganglia.ganglia_host = "http://ganglia-host:1234/path/to/ganglia"
        ganglia.window = Window.new(:hour, :length => 1.hour)
        ganglia.size = "xlarge"
        ganglia.title = "The Graph Title"
        ganglia.embed = true
      end
    end
    
    subject { ganglia }

    it { should be_a Widget }
    
    its(:size) { should == "xlarge" }
    its(:title) { should == "The Graph Title" }
    its(:embed) { should be_true }

    describe "#size" do
      context "default" do
        subject { described_class.new.size }
        it { should == "large" }
      end

      it "validates that it is in Ganglia::SIZES" do
        described_class::SIZES.each do |size|
          expect { subject.size = size }.to_not raise_error ArgumentError
        end
        expect { subject.size = :foobar }.to raise_error ArgumentError
      end
    end

    describe "#embed" do
      context "default" do
        subject { described_class.new.embed }
        it { should be_true }
      end
    end

    describe "#to_url" do
      subject { ganglia.to_url }
      
      it { should =~ /http:\/\/ganglia-host:1234\/path\/to/ }
      it { should =~ /z=xlarge/ }
      it { should =~ /title=The\+Graph\+Title/ }
      it { should =~ /embed=1/ }

      it "includes the window" do
        ganglia.window.ganglia_params.each do |k, v|
          subject.should =~ /#{Regexp.escape "#{k}=#{Rack::Utils.escape(v)}"}/
        end
      end
    end
    
    describe "#to_html" do
      subject { ganglia.to_html }
      it { should == "<img src=\"#{ganglia.to_url}\"/>" }
    end
  end
end