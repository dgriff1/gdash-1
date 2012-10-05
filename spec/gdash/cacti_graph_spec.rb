require "spec_helper"

module GDash
  describe CactiGraph, :type => :request do
    let :graph do
      described_class.new do |graph|
        graph.graph_id = 1
        graph.rra_id = 2
        graph.cacti_host = "https://cacti-host/path/to/cacti"
      end
    end
    
    let :window do
      Window.new :foo do |w|
        w.cacti_params = { :foo => :bar, :baz => :quux }
      end
    end
    
    subject { graph }

    it { should be_a Widget }
    
    its(:graph_id) { should == 1 }
    its(:rra_id) { should == 2 }
    its(:cacti_host) { should == "https://cacti-host/path/to/cacti" }
    
    describe "#to_url" do
      subject { graph.to_url }

      it { should =~ /https:\/\/cacti-host\/path\/to\/cacti\/graph_image.php\?/ }
      it { should =~ /action=view/ }
      it { should =~ /local_graph_id=1/ }
      it { should =~ /rra_id=2/ }
      
      context "with a window" do
        before { graph.window = window }
        it { should =~ /foo=bar/ }
        it { should =~ /baz=quux/ }
      end
    end
    
    describe "#to_html" do
      subject { graph.to_html }
      it { should have_selector "img", :src => graph.to_url }
    end
  end
end