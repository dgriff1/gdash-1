require "spec_helper"

module GDash
  describe GangliaReport do
    let!(:data_center) { DataCenter.define :foo, :ganglia_host => "http://ganglia-host:1234/path/to/ganglia" }

    let :report do
      described_class.new do |report|
        report.data_center = :foo
        report.window = Window.new(:hour, :length => 1.hour)
        report.size = "xlarge"
        report.title = "The Graph Title"
        report.report = "the_report"
        report.cluster = "The Cluster"
        report.host = "the-host-01"
      end
    end
    
    subject { report }

    it { should be_a Ganglia }
    
    its(:size) { should == "xlarge" }
    its(:title) { should == "The Graph Title" }
    its(:report) { should == "the_report" }
    its(:cluster) { should == "The Cluster" }
    its(:host) { should == "the-host-01" }

    describe "#to_url" do
      subject { report.to_url }

      it { should =~ /z=xlarge/ }
      it { should =~ /title=The\+Graph\+Title/ }
      it { should =~ /g=the_report/ }
      it { should =~ /h=the-host-01/ }
      it { should =~ /c=The\+Cluster/ }

      it "includes the window" do
        report.window.ganglia_params.each do |k, v|
          subject.should =~ /#{Regexp.escape "#{k}=#{Rack::Utils.escape(v)}"}/
        end
      end
      
      context "without host" do
        before { report.host = nil }
        it { should_not =~ /h=/ }
      end
    end
  end
end