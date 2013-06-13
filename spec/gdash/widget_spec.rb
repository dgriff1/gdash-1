require "spec_helper"

module GDash
  describe Widget do
    let :widget do
      Widget.new :foo, :title => "Test Widget" do
        description "A widget for testing"
      end
    end

    subject { widget }

    it { should be_a Base }
    its(:name) { should == "foo" }
    its(:title) { should == "Test Widget" }
    its(:description) { should == "A widget for testing" }

    describe "consutructor on section" do
      let(:section) { Section.new :foo }

      subject do
        section.test_widget :bar, :foo => "baz" do
          bar "quux"
        end
      end

      it { should be_a TestWidget }
      its(:name) { should == "bar" }
      its(:foo) { should == "baz" }
      its(:bar) { should == "quux" }
    end
  end
end