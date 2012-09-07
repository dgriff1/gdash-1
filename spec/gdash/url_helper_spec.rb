require "spec_helper"

module GDash
  describe UrlHelper do
    subject do
      klass = Class.new.send :include, UrlHelper
      klass.new
    end

    describe :dashboards_path do
      it "should generate /" do
        subject.dashboards_path.should == "/"
      end
    end

    describe :dashboard_path do
      it "should generate /:name" do
        subject.dashboard_path(:foo).should == "/foo"
      end

      it "should take a window option" do
        subject.dashboard_path(:foo, :window => "hour").should == "/foo?window=hour"
      end
    end
  end
end