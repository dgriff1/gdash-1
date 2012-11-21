require "spec_helper"

class TestWidget < GDash::Widget
  attr_accessor :foo, :bar
end

module GDash
  describe Widget do
    let(:widget) { TestWidget.new }
    subject { widget }

    describe :define do
      context "returns the named widget" do
        let(:one) { TestWidget.define :foo }
        let(:two) { TestWidget.define :foo }
        let(:three) { TestWidget.define :bar }

        subject { one }

        it { should be_a TestWidget }
        it { should == two }
        it { should_not == three }
      end

      context "takes options" do
        let(:widget) { TestWidget.define :foo, :foo => "baz", :bar => "quux" }

        subject { widget }

        its(:foo) { should == "baz" }
        its(:bar) { should == "quux" }
      end

      context "takes a name" do
        let(:widget) { TestWidget.define :foo }

        its(:name) { should == "foo" }
      end

      it "yields the widget to the block" do
        yielded = nil
        returned = TestWidget.define :foo do |w|
          yielded = w
        end
        yielded.should == returned

        TestWidget.define :foo do |w|
          w.should == yielded
        end
      end
    end

    describe :[] do
      let!(:widget) { TestWidget.define :foo }

      subject { Widget }

      its(["foo"]) { should == widget }
    end

    describe :initialize do
      context "takes options" do
        let(:widget) { TestWidget.new :foo => "Foo", :bar => "Bar" }

        its(:foo) { should == "Foo" }
        its(:bar) { should == "Bar" }
      end

      it "yields itself to the block" do
        yielded = nil
        widget = TestWidget.new do |w|
          yielded = w
        end
        yielded.should == widget
      end
    end

    describe :children do
      subject { widget.children }

      it { should == [] }
    end

    describe :renderable_children do
      let!(:one) { widget.section }
      let!(:two) { widget.section }
      let!(:three) { widget.dashboard :bar }

      subject { widget.renderable_children }

      it { should include one }
      it { should include two }
      it { should_not include three }
    end

    describe :nested_dashboards do
      let!(:one) { widget.section }
      let!(:two) { widget.section }
      let!(:three) { widget.dashboard :bar }

      subject { widget.nested_dashboards }

      it { should_not include one }
      it { should_not include two }
      it { should include three }
    end

    describe :nested_dashboards? do
      context "with nested dashboards" do
        let!(:bar) { widget.dashboard :bar }

        it { should be_nested_dashboards }
      end

      context "without nested dashboards" do
        it { should_not be_nested_dashboards }
      end
    end

    describe :ganglia_graph do
      let(:graph) { GangliaGraph.define :some_graph }
      before { GangliaGraph.stub! :new => graph }
      before { widget.ganglia_graph :some_graph }

      subject { widget.children.last }

      it { should == graph }
      its(:parent) { should == widget }

      it "yields the ganglia graph" do
        GangliaGraph.stub!(:new).and_yield(graph).and_return graph

        yielded = nil
        subject.ganglia_graph :some_graph do |g|
          yielded = g
        end

        yielded.should == graph
      end
    end

    describe :ganglia_report do
      let(:report) { GangliaReport.define :some_report }
      before { GangliaReport.stub! :new => report }
      before { widget.ganglia_report :some_report }

      subject { widget.children.last }

      it { should == report }
      its(:parent) { should == widget }

      it "yields the ganglia report" do
        GangliaReport.stub!(:new).and_yield(report).and_return report

        yielded = nil
        subject.ganglia_report :some_report do |g|
          yielded = g
        end

        yielded.should == report
      end
    end

    describe :cacti_graph do
      let(:graph) { CactiGraph.define :some_graph }
      before { CactiGraph.stub! :new => graph }
      before { widget.cacti_graph :some_graph }

      subject { widget.children.last }

      it { should == graph }
      its(:parent) { should == widget }

      it "yields the cacti graph" do
        CactiGraph.stub!(:new).and_yield(graph).and_return graph

        yielded = nil
        subject.cacti_graph :some_graph do |g|
          yielded = g
        end

        yielded.should == graph
      end
    end

    describe :dashboard do
      let(:dashboard) { Dashboard.define :some_dashboard }
      before { Dashboard.stub! :new => dashboard }
      before { widget.dashboard :some_dashboard }

      subject { widget.children.last }

      it { should == dashboard }
      its(:parent) { should == widget }

      it "yields the dashboard" do
        Dashboard.stub!(:new).and_yield(dashboard).and_return dashboard

        yielded = nil
        subject.dashboard :some_dashboard do |g|
          yielded = g
        end

        yielded.should == dashboard
      end
    end

    describe :section do
      let(:section) { Section.new }
      before { Section.stub! :new => section }
      before { widget.section :some_section }

      subject { widget.children.last }

      it { should == section }
      its(:parent) { should == widget }

      it "yields the section" do
        Section.stub!(:new).and_yield(section).and_return section

        yielded = nil
        subject.section do |g|
          yielded = g
        end

        yielded.should == section
      end
    end

    describe :parent do
      context "default" do
        its(:parent) { should be_nil }
      end

      context "with a parent" do
        before { subject.parent = "Foo" }
        its(:parent) { should == "Foo" }
      end
    end

    describe :window do
      let(:window) { Window.new :foo }
      before { widget.window = window }

      its(:window) { should == window }

      context "falls back to the parent's value" do
        let(:child) { Widget.new :parent => widget }

        subject { child }

        its(:window) { should == widget.window }
      end

      context "default" do
        before { widget.window = nil }

        its(:window) { should == Window.default }
      end
    end

    describe :data_center do
      let!(:foo) { DataCenter.define :foo }
      before { widget.data_center = :foo }

      its(:data_center) { should == foo }

      context "falls back to the parent's value" do
        let(:child) { Widget.new :parent => widget }

        subject { child }

        its(:data_center) { should == widget.data_center }
      end
    end
  end
end