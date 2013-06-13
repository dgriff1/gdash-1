require "spec_helper"
require "gdash/windows"

module GDash
  describe Dashboard do
    let :dashboard do
      GDash.dashboard :some_dashboard do
        title "The Dashboard Title"
        description "A description of the dashboard"
        refresh 42

        page :page_one
        page :page_two, :foo => :bar
        page :page_three, :foo => :bar do
          title "A custom page"
        end
      end
    end
    let(:foo) { Dashboard.new :foo, :title => "foo" }
    let(:bar) { Dashboard.new :bar, :title => "bar" }
    
    subject { dashboard }

    it { should be_a Named }
    
    its(:name) { should == "some_dashboard" }
    its(:title) { should == "The Dashboard Title" }
    its(:description) { should == "A description of the dashboard" }
    its(:refresh) { should == 42 }
    its(:windows) { should == Window.all.sort }

    describe "#find" do
      context "when page exists" do
        subject { dashboard.find :page_one }

        it { should be_a Page }
        its(:name) { should == "page_one" }
      end

      context "when page doesn't exist" do
        subject { dashboard.find :i_dont_exist }

        it { should be_nil }
      end
    end

    describe "#windows" do
      it "sorts the child windows" do
        subject.custom_window :foo, :length => 420.minutes
        subject.custom_window :foo, :length => 42.minutes
        subject.windows.should == subject.windows.sort
      end
    end

    describe "#custom_window" do
      let :window do
        dashboard.custom_window :foo do

        end
      end

      its(:windows) { should include window }

      it "yields the window to the block" do
        yielded = nil
        returned = subject.custom_window :foo do |w|
          yielded = w
        end
        yielded.should == returned
      end
    end

    describe "#page" do
      subject { dashboard.pages }

      its(:length) { should == 3 }

      context "first" do
        subject { dashboard.pages[0] }

        it { should be_a Page }
        its(:name) { should == "page_one" }
      end

      context "second" do
        subject { dashboard.pages[1] }

        it { should be_a Page }
        its(:name) { should == "page_two" }
        its(:options) { should == { "foo" => :bar } }
      end

      context "third" do
        subject { dashboard.pages[2] }

        it { should be_a Page }
        its(:name) { should == "page_three" }
        its(:title) { should == "A custom page" }
        its(:options) { should == { "foo" => :bar } }
      end
    end

    describe "#<=>" do
      it "orders on title" do
        [foo, bar].sort.should == [bar, foo]
      end
    end
  end
end