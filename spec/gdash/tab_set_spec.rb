require "spec_helper"

module GDash
  describe TabSet do
    let(:tab_set) do
      TabSet.new :foo do
        tab :bar do
          title "The Bar Tab"
        end

        tab :baz do
          title "The Baz Tab"
        end
      end
    end

    subject { tab_set }

    it { should be_a Base }

    describe "#tabs" do
      let(:tabs) { tab_set.tabs }

      context "first" do
        subject { tabs[0] }

        it { should be_a Tab }
        its(:name) { should == "bar" }
        its(:title) { should == "The Bar Tab" }
      end

      context "second" do
        subject { tabs[1] }

        it { should be_a Tab }
        its(:name) { should == "baz" }
        its(:title) { should == "The Baz Tab" }
      end

      context "default" do
        subject { TabSet.new(:foo).tabs }
        it { should be_empty }
      end
    end

    describe "#tab" do
      subject { tab_set.tab :bar }
      it { should == tab_set.tabs[0] }
    end
  end
end