require "spec_helper"

class TestWidget < GDash::Widget
  attr_accessor :foo, :bar
end

module GDash
  describe Widget do
    subject do
      TestWidget.new
    end

    describe :initialize do
      it "should take options" do
        lambda { TestWidget.new }.should_not raise_error
        widget = TestWidget.new :foo => "Foo", :bar => "Bar"

        widget.foo.should == "Foo"
        widget.bar.should == "Bar"
      end

      it "should yield itself to the block" do
        yielded = nil
        widget = TestWidget.new do |w|
          yielded = w
        end
        yielded.should == widget
      end
    end

    describe :children do
      it "should default to an empty array" do
        subject.children.should == []
      end
    end

    describe :ganglia_graph do
      before do
        @ganglia_graph = GangliaGraph.new
        GangliaGraph.stub!(:new).and_return @ganglia_graph
      end

      it "should add a ganglia graph child" do
        subject.ganglia_graph
        subject.children.last.should == @ganglia_graph
      end

      it "should yield the ganglia graph" do
        GangliaGraph.stub!(:new).and_yield(@ganglia_graph).and_return @ganglia_graph

        yielded = nil
        subject.ganglia_graph do |g|
          yielded = g
        end

        yielded.should == @ganglia_graph
      end

      it "should set the parent" do
        subject.ganglia_graph
        @ganglia_graph.parent.should == subject
      end
    end

    describe :ganglia_report do
      before do
        @ganglia_report = GangliaReport.new
        GangliaReport.stub!(:new).and_return @ganglia_report
      end

      it "should add a ganglia report child" do
        subject.ganglia_report
        subject.children.last.should == @ganglia_report
      end

      it "should yield the ganglia report" do
        GangliaReport.stub!(:new).and_yield(@ganglia_report).and_return @ganglia_report

        yielded = nil
        subject.ganglia_report do |r|
          yielded = r
        end

        yielded.should == @ganglia_report
      end

      it "should set the parent" do
        subject.ganglia_report
        @ganglia_report.parent.should == subject
      end
    end

    describe :cacti_graph do
      before do
        @cacti_graph = CactiGraph.new
        CactiGraph.stub!(:new).and_return @cacti_graph
      end

      it "should add a cacti graph child" do
        subject.cacti_graph
        subject.children.last.should == @cacti_graph
      end

      it "should yield the ganglia graph" do
        CactiGraph.stub!(:new).and_yield(@cacti_graph).and_return @cacti_graph

        yielded = nil
        subject.cacti_graph do |g|
          yielded = g
        end

        yielded.should == @cacti_graph
      end

      it "should set the parent" do
        subject.cacti_graph
        @cacti_graph.parent.should == subject
      end
    end

    describe :dashboard do
      before do
        @dashboard = Dashboard.new :some_dashboard
        Dashboard.stub!(:new).and_return @dashboard
      end

      it "should add a dashboard child" do
        subject.dashboard
        subject.children.last.should == @dashboard
      end

      it "should yield the dashboard" do
        Dashboard.stub!(:new).and_yield(@dashboard).and_return @dashboard

        yielded = nil
        subject.dashboard do |d|
          yielded = d
        end

        yielded.should == @dashboard
      end

      it "should set the parent" do
        subject.dashboard
        @dashboard.parent.should == subject
      end
    end

    describe :section do
      before do
        @section = Section.new
        Section.stub!(:new).and_return @section
      end

      it "should add a section child" do
        subject.section
        subject.children.last.should == @section
      end

      it "should yield the section" do
        Section.stub!(:new).and_yield(@section).and_return @section

        yielded = nil
        subject.section do |s|
          yielded = s
        end

        yielded.should == @section
      end

      it "should set the parent" do
        subject.section
        @section.parent.should == subject
      end
    end

    describe :parent do
      it "should have accessors" do
        subject.parent = "Foo"
        subject.parent.should == "Foo"
      end
    end

    describe :window do
      it "should have an accessor" do
        subject.window = "2hr"
        subject.window.should == "2hr"
      end

      it "should fallback to the parent's value" do
        widget = Widget.new :window => "2hr"
        subject.parent = widget
        subject.window.should == "2hr"
      end

      it "should default to an hour" do
        subject.window.should == "hour"
      end

      it "should validate that it is in Ganglia::WINDOWS" do
        Ganglia::WINDOWS.values.each do |window|
          lambda { subject.window = window }.should_not raise_error
        end

        lambda { subject.window = :foobar }.should raise_error
      end
    end

    describe :ganglia_host do
      it "should have an accessor" do
        subject.ganglia_host = "Foo"
        subject.ganglia_host.should == "Foo"
      end

      it "should fallback to the parent's value" do
        widget = Widget.new :ganglia_host => "Foo"
        subject.parent = widget
        subject.ganglia_host.should == "Foo"
      end
    end

    describe :graphite_host do
      it "should have an accessor" do
        subject.graphite_host = "Foo"
        subject.graphite_host.should == "Foo"
      end

      it "should fallback to the parent's value" do
        widget = Widget.new :graphite_host => "Foo"
        subject.parent = widget
        subject.graphite_host.should == "Foo"
      end
    end

    describe :cacti_host do
      it "should have an accessor" do
        subject.cacti_host = "Foo"
        subject.cacti_host.should == "Foo"
      end

      it "should fallback to the parent's value" do
        widget = Widget.new :cacti_host => "Foo"
        subject.parent = widget
        subject.cacti_host.should == "Foo"
      end
    end
  end
end