require "spec_helper"

module GDash
  describe CactiGraph, :type => :feature do
    let!(:data_center) { DataCenter.define :foo, :cacti_host => "https://cacti-host/path/to/cacti" }

    let :graph do
      described_class.new do |graph|
        graph.graph_id = 1
        graph.rra_id = 2
        graph.data_center = :foo
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
      it { should have_selector "img[src=#{graph.to_url.inspect}]" }
    end
  end
end