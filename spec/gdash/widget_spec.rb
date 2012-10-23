require "spec_helper"

class TestWidget < GDash::Widget
  attr_accessor :foo, :bar
end

module GDash
  describe Widget do
    subject do
      TestWidget.new
    end

    describe :define do
      it "should return the named widget" do
        widget_one = TestWidget.define :foo
        widget_one.should be_a TestWidget

        widget_two = TestWidget.define :foo
        widget_two.should == widget_one

        widget_three = TestWidget.define :bar
        widget_three.should_not == widget_one
      end

      it "should take options" do
        TestWidget.define(:foo, :foo => "bar").foo.should == "bar"
        TestWidget.define(:foo, :bar => "quux").bar.should == "quux"
      end

      it "should take a name" do
        TestWidget.define(:foo).name.should == "foo"
      end

      it "should yield the widget to the block" do
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
      it "should find a defined widget" do
        widget = TestWidget.define :foo
        Widget["foo"].should == widget
      end
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

    describe :renderable_children do
      it "should return non-dashboard children" do
        section_one = subject.section
        dashboard = subject.dashboard :bar
        section_two = subject.section

        subject.renderable_children.should be_include section_one
        subject.renderable_children.should be_include section_two
        subject.renderable_children.should_not be_include dashboard
      end
    end

    describe :nested_dashboards do
      it "should return only dashboard children" do
        section_one = subject.section
        dashboard = subject.dashboard :bar
        section_two = subject.section

        subject.nested_dashboards.should_not be_include section_one
        subject.nested_dashboards.should_not be_include section_two
        subject.nested_dashboards.should be_include dashboard
      end
    end

    describe :nested_dashboards? do
      it "should return true if there are nested dashboards" do
        subject.dashboard :bar
        subject.should be_nested_dashboards
      end

      it "should return false if there are no nested dashboards" do
        subject.should_not be_nested_dashboards
      end
    end

    describe :ganglia_graph do
      before do
        @ganglia_graph = GangliaGraph.define :some_graph
        GangliaGraph.stub!(:new).and_return @ganglia_graph
      end

      it "should add a ganglia graph child" do
        subject.ganglia_graph :some_graph
        subject.children.last.should == @ganglia_graph
      end

      it "should yield the ganglia graph" do
        GangliaGraph.stub!(:new).and_yield(@ganglia_graph).and_return @ganglia_graph

        yielded = nil
        subject.ganglia_graph :some_graph do |g|
          yielded = g
        end

        yielded.should == @ganglia_graph
      end

      it "should set the parent" do
        subject.ganglia_graph :some_graph
        @ganglia_graph.parent.should == subject
      end
    end

    describe :ganglia_report do
      before do
        @ganglia_report = GangliaReport.define :some_report
        GangliaReport.stub!(:new).and_return @ganglia_report
      end

      it "should add a ganglia report child" do
        subject.ganglia_report :some_report
        subject.children.last.should == @ganglia_report
      end

      it "should yield the ganglia report" do
        GangliaReport.stub!(:new).and_yield(@ganglia_report).and_return @ganglia_report

        yielded = nil
        subject.ganglia_report :some_report do |r|
          yielded = r
        end

        yielded.should == @ganglia_report
      end

      it "should set the parent" do
        subject.ganglia_report :some_report
        @ganglia_report.parent.should == subject
      end
    end

    describe :cacti_graph do
      before do
        @cacti_graph = CactiGraph.define :some_graph
        CactiGraph.stub!(:new).and_return @cacti_graph
      end

      it "should add a cacti graph child" do
        subject.cacti_graph :some_graph
        subject.children.last.should == @cacti_graph
      end

      it "should yield the ganglia graph" do
        CactiGraph.stub!(:new).and_yield(@cacti_graph).and_return @cacti_graph

        yielded = nil
        subject.cacti_graph :some_graph do |g|
          yielded = g
        end

        yielded.should == @cacti_graph
      end

      it "should set the parent" do
        subject.cacti_graph :some_graph
        @cacti_graph.parent.should == subject
      end
    end

    describe :dashboard do
      before do
        @dashboard = Dashboard.define :some_dashboard
        Dashboard.stub!(:new).and_return @dashboard
      end

      it "should add a dashboard child" do
        subject.dashboard :some_dashboard
        subject.children.last.should == @dashboard
      end

      it "should yield the dashboard" do
        Dashboard.stub!(:new).and_yield(@dashboard).and_return @dashboard

        yielded = nil
        subject.dashboard :some_dashboard do |d|
          yielded = d
        end

        yielded.should == @dashboard
      end

      it "should set the parent" do
        subject.dashboard :some_dashboard
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
        window = Window.new :foo
        subject.window = window
        subject.window.should == window
      end

      it "should fallback to the parent's value" do
        window = Window.new :foo
        widget = Widget.new :window => window
        subject.parent = widget
        subject.window.should == window
      end

      it "should default to the default window" do
        subject.window.should == Window.default
      end
    end

    describe :data_center do
      let!(:foo) { DataCenter.define :foo }

      it "should have an accessor" do
        subject.data_center = :foo
        subject.data_center.should == foo
      end

      it "should fall back to the parent's value" do
        widget = Widget.new :data_center => :foo
        subject.parent = widget
        widget.data_center.should == foo
      end
    end

    #describe :ganglia_host do
    #  it "should have an accessor" do
    #    subject.ganglia_host = "Foo"
    #    subject.ganglia_host.should == "Foo"
    #  end
    #
    #  it "should fallback to the parent's value" do
    #    widget = Widget.new :ganglia_host => "Foo"
    #    subject.parent = widget
    #    subject.ganglia_host.should == "Foo"
    #  end
    #end
    #
    #describe :graphite_host do
    #  it "should have an accessor" do
    #    subject.graphite_host = "Foo"
    #    subject.graphite_host.should == "Foo"
    #  end
    #
    #  it "should fallback to the parent's value" do
    #    widget = Widget.new :graphite_host => "Foo"
    #    subject.parent = widget
    #    subject.graphite_host.should == "Foo"
    #  end
    #end
    #
    #describe :cacti_host do
    #  it "should have an accessor" do
    #    subject.cacti_host = "Foo"
    #    subject.cacti_host.should == "Foo"
    #  end
    #
    #  it "should fallback to the parent's value" do
    #    widget = Widget.new :cacti_host => "Foo"
    #    subject.parent = widget
    #    subject.cacti_host.should == "Foo"
    #  end
    #end
    #
    #describe :nagios_host do
    #  it "should have an accessor" do
    #    subject.nagios_host = "Foo"
    #    subject.nagios_host.should == "Foo"
    #  end
    #
    #  it "should fallback to the parent's value" do
    #    widget = Widget.new :nagios_host => "Foo"
    #    subject.parent = widget
    #    subject.nagios_host.should == "Foo"
    #  end
    #end
    #
    #describe :nagios_username do
    #  it "should have an accessor" do
    #    subject.nagios_username = "Foo"
    #    subject.nagios_username.should == "Foo"
    #  end
    #
    #  it "should fallback to the parent's value" do
    #    widget = Widget.new :nagios_username => "Foo"
    #    subject.parent = widget
    #    subject.nagios_username.should == "Foo"
    #  end
    #end
    #
    #describe :nagios_password do
    #  it "should have an accessor" do
    #    subject.nagios_password = "Foo"
    #    subject.nagios_password.should == "Foo"
    #  end
    #
    #  it "should fallback to the parent's value" do
    #    widget = Widget.new :nagios_password => "Foo"
    #    subject.parent = widget
    #    subject.nagios_password.should == "Foo"
    #  end
    #end
  end
end