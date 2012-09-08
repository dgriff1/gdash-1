require "spec_helper"

GDash::Dashboard.new :foo do |dashboard|
  dashboard.dashboard :bar
end

GDash::Dashboard.new :baz

module GDash
  describe Helper do
    subject do
      klass = Class.new.send :include, Helper
      klass.new
    end

    describe :dashboards_path do
      it "should generate /" do
        subject.dashboards_path.should == "/"
      end
    end

    describe :dashboard_path do
      it "should generate /:name" do
        subject.dashboard_path(Dashboard[:foo]).should == "/foo"
      end

      it "should take a window option" do
        subject.dashboard_path(Dashboard[:foo], :window => "hour").should == "/foo?window=hour"
      end
    end

    describe :build_sidebar do
      it "should create a navbar" do
        subject.build_sidebar
      end
    end
  end
end