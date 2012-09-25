require "spec_helper"

module GDash
  describe Dashboard do
    subject do
      Dashboard.new :some_dashboard
    end

    describe :define do
      it "should require a name" do
        lambda { Dashboard.define }.should raise_error ArgumentError

        dashboard = Dashboard.define :some_dashboard
        dashboard.name.should == :some_dashboard
      end

      it "should register itself" do
        dashboard = Dashboard.define :some_dashboard
        Dashboard[:some_dashboard].should == dashboard
      end

      it "should register itself as a top-level dashboard" do
        dashboard = Dashboard.define :some_dashboard
        Dashboard.toplevel.include?(dashboard).should be_true
      end

      it "should yield itself to the block" do
        yielded = nil
        dashboard = Dashboard.define :some_dashboard do |d|
          yielded = d
        end
        dashboard.should == yielded
      end
    end

    describe :initialize do
      it "should require a name" do
        lambda { Dashboard.new }.should raise_error ArgumentError

        dashboard = Dashboard.new :some_dashboard
        dashboard.name.should == :some_dashboard
        Dashboard[:some_dashboard].should == dashboard
      end

      it "should register itself" do
        dashboard = Dashboard.new :some_dashboard
        Dashboard[:some_dashboard].should == dashboard
      end

      it "should yield itself to the block" do
        yielded = nil
        dashboard = Dashboard.new :some_dashboard do |d|
          yielded = d
        end
        dashboard.should == yielded
      end
    end

    describe :each do
      it "should yield each registered dashboard" do
        Dashboard.new :foo
        Dashboard.new :bar

        dashboards = []
        Dashboard.each do |dashboard|
          dashboards << dashboard
        end
        dashboards.include?(Dashboard[:foo]).should be_true
        dashboards.include?(Dashboard[:bar]).should be_true
      end
    end

    it "should be a widget" do
      subject.should be_a Widget
    end

    describe :title do
      it "should have an accessor" do
        subject.title = "Foo"
        subject.title.should == "Foo"
      end
    end

    describe :description do
      it "should have an accessor" do
        subject.description = "Foo"
        subject.description.should == "Foo"
      end
    end

    describe :refresh do
      it "should have an accessor" do
        subject.refresh = 5
        subject.refresh.should == 5
      end

      it "should default to 60s" do
        subject.refresh.should == 60
      end
    end

    describe :windows do
      it "should default to the global windows" do
        subject.windows.should == Window.all
      end

      it "should be sorted" do
        subject.custom_window :foo, :length => 420.minutes
        subject.custom_window :foo, :length => 42.minutes
        subject.windows.should == subject.windows.sort
      end
    end

    describe :custom_window do
      it "should add a window to the windows" do
        window = subject.custom_window :foo
        subject.windows.should be_include window
        Window.all.should_not be_include window
      end

      it "should yield the window to the block" do
        yielded = nil
        returned = subject.custom_window :foo do |w|
          yielded = w
        end
        yielded.should == returned
      end
    end

    describe :<=> do
      it "should sort on title" do
        foo = Dashboard.new :a, :title => "foo"
        bar = Dashboard.new :b, :title => "bar"
        [foo, bar].sort.should == [bar, foo]
      end
    end
  end
end