require "spec_helper"

module GDash
  describe Dashboard do
    let(:dashboard) do
      described_class.define :some_dashboard do |dashboard|
        dashboard.title = "The Dashboard Title"
        dashboard.description = "A description of the dashboard"
        dashboard.refresh = 42
      end
    end
    let(:foo) { described_class.new :a, :title => "foo" }
    let(:bar) { described_class.new :b, :title => "bar" }
    
    subject do
      dashboard
    end

    it { should be_a Widget }
    
    its(:name) { should == :some_dashboard }
    its(:title) { should == "The Dashboard Title" }
    its(:description) { should == "A description of the dashboard" }
    its(:refresh) { should == 42 }
    its(:windows) { should == Window.all }

    describe ".define" do
      it "requires a name" do
        expect { described_class.define }.to raise_error ArgumentError
      end

      it "registers itself" do
        dashboard = described_class.define :some_dashboard
        described_class[:some_dashboard].should == dashboard
      end

      it "registers itself as a top-level dashboard" do
        dashboard = described_class.define :some_dashboard
        described_class.toplevel.include?(dashboard).should be_true
      end
    end

    describe "#initialize" do
      it "requires a name" do
        expect { described_class.new }.to raise_error ArgumentError
      end

      it "registers itself" do
        dashboard = described_class.new :some_dashboard
        described_class[:some_dashboard].should == dashboard
      end
    end

    describe "#each" do
      let!(:foo) { described_class.new :foo }
      let!(:bar) { described_class.new :bar }
      
      it "yields each registered dashboard" do
        dashboards = []
        described_class.each do |dashboard|
          dashboards << dashboard
        end
        dashboards.should be_include foo
        dashboards.should be_include bar
      end
    end

    describe "#windows" do
      it "sorts the child windows" do
        subject.custom_window :foo, :length => 420.minutes
        subject.custom_window :foo, :length => 42.minutes
        subject.windows.should == subject.windows.sort
      end
    end

    describe "#custom_window" do
      let!(:window) { subject.custom_window :foo }
      its(:windows) { should be_include window }

      it "yields the window to the block" do
        yielded = nil
        returned = subject.custom_window :foo do |w|
          yielded = w
        end
        yielded.should == returned
      end
    end

    describe "#<=>" do
      it "orders on title" do
        [foo, bar].sort.should == [bar, foo]
      end
    end
  end
end