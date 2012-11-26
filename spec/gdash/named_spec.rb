require "spec_helper"

class TestNamed < GDash::Named
  attr_accessor :foo, :bar
end

module GDash
  describe Named do
    let :named do
      TestNamed.new :name => "foo", :foo => :baz, :bar => :quux
    end

    subject { named }

    it { should be_a Widget }
    its(:name) { should == "foo" }
    its(:foo) { should == :baz }
    its(:bar) { should == :quux }

    describe :define do
      context "returns the named widget" do
        let(:one) { TestNamed.define :foo }
        let(:two) { TestNamed.define :foo }
        let(:three) { TestNamed.define :bar }

        subject { one }

        it { should be_a TestNamed }
        it { should == two }
        it { should_not == three }
      end

      context "takes options" do
        let(:named) { TestNamed.define :foo, :foo => "baz", :bar => "quux" }

        subject { named }

        its(:foo) { should == "baz" }
        its(:bar) { should == "quux" }
      end

      context "takes a name" do
        let(:named) { TestNamed.define :foo }

        its(:name) { should == "foo" }
      end

      it "yields the widget to the block" do
        yielded = nil
        returned = TestNamed.define :foo do |w|
          yielded = w
        end
        yielded.should == returned

        TestNamed.define :foo do |w|
          w.should == yielded
        end
      end
    end

    describe :[] do
      let!(:named) { TestNamed.define :foo }

      subject { Widget }

      its(["foo"]) { should == named }
    end
  end
end