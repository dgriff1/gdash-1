require "spec_helper"

module GDash
  describe Dashboard do
    subject do
      Dashboard.new :some_dashboard
    end

    describe :initialize do
      it "should require a name" do
        lambda { Dashboard.new }.should raise_error ArgumentError

        dashboard = Dashboard.new :some_dashboard
        dashboard.name.should == :some_dashboard
        Dashboard[:some_dashboard].should == dashboard
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
  end
end