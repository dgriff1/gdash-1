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

    describe :graph do
      before do
        @graph = Graph.new
        Graph.stub!(:new).and_return @graph
      end

      it "should add a graph child" do
        subject.graph
        subject.children.last.should == @graph
      end

      it "should yield the graph" do
        Graph.stub!(:new).and_yield(@graph).and_return @graph

        yielded = nil
        subject.graph do |g|
          yielded = g
        end

        yielded.should == @graph
      end

      it "should set the parent" do
        subject.graph
        @graph.parent.should == subject
      end
    end

    describe :report do
      before do
        @report = Report.new
        Report.stub!(:new).and_return @report
      end

      it "should add a graph child" do
        subject.report
        subject.children.last.should == @report
      end

      it "should yield the report" do
        Report.stub!(:new).and_yield(@report).and_return @report

        yielded = nil
        subject.report do |r|
          yielded = r
        end

        yielded.should == @report
      end

      it "should set the parent" do
        subject.report
        @report.parent.should == subject
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
  end
end