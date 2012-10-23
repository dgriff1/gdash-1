require "spec_helper"

module GDash
  describe GangliaGraph do
    let!(:data_center) { DataCenter.define :foo, :ganglia_host => "http://ganglia-host:1234/path/to/ganglia" }

    let :graph do
      described_class.new do |graph|
        graph.data_center = :foo
        graph.window = Window.new(:hour, :length => 1.hour)
        graph.size = "xlarge"
        graph.title = "The Graph Title"
        graph.vertical_label = "A Label"
        graph.limits = (1..10)
        graph.hosts = "the-host-0[123]"
        graph.metrics = "metric.name.[\\d]"
        graph.type = "stack"
        graph.legend = true
      end
    end
    
    subject { graph }

    it { should be_a Ganglia }
    
    its(:hosts) { should == "the-host-0[123]" }
    its(:metrics) { should == "metric.name.[\\d]" }
    its(:vertical_label) { should == "A Label" }
    its(:upper_limit) { should == 10 }
    its(:lower_limit) { should == 1 }
    its(:type) { should == "stack" }
    its(:legend) { should be_true }
    its(:aggregate) { should be_true }

    describe "#to_url" do
      subject { graph.to_url }
      
      it { should =~ /z=xlarge/ }
      it { should =~ /title=The\+Graph\+Title/ }
      it { should =~ /vl=A\+Label/ }
      it { should =~ /x=10/ }
      it { should =~ /n=1/ }
      it { should =~ /hreg\[\]=#{Rack::Utils.escape("the-host-0[123]")}/ }
      it { should =~ /mreg\[\]=#{Rack::Utils.escape("metric.name.[\\d]")}/ }
      it { should =~ /gtype=stack/ }
      it { should =~ /aggregate=1/ }
      
      context "with legend" do
        before { graph.legend = true }
        it { should =~ /glegend=show/ }
      end
      
      context "without legend" do
        before { graph.legend = false }
        it { should =~ /glegend=hide/ }
      end

      it "includes the window" do
        graph.window.ganglia_params.each do |k, v|
          subject.should =~ /#{Regexp.escape "#{k}=#{Rack::Utils.escape(v)}"}/
        end
      end
    end
  end
end