require "spec_helper"

module GDash
  describe Section do
    subject do
      Section.new
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

    describe :width do
      it "should have an accessor" do
        subject.width = 42
        subject.width.should == 42
      end

      it "should default to 3" do
        subject.width.should == 3
      end
    end
  end
end