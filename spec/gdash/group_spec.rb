require "spec_helper"

module GDash
  describe Group do
    subject do
      Group.new
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
  end
end