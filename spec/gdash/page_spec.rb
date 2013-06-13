require "spec_helper"

module GDash
  describe Page do
    before do
      GDash.section :some_section, :title => "A Test Section" do
        description "A section for testing"
      end
    end

    let :page do
      GDash.page :some_page do
        title "The Page Title"
        description "A description of the page"
        refresh 42
      end
    end
    let(:foo) { Page.new :foo, :title => "foo" }
    let(:bar) { Page.new :bar, :title => "bar" }
    
    subject { page }

    it { should be_a Base }
    
    its(:name) { should == "some_page" }
    its(:title) { should == "The Page Title" }
    its(:description) { should == "A description of the page" }
    its(:refresh) { should == 42 }

    describe "#section" do
      let :section do
        page.section :some_section, :title => "A Test Section" do
          description "A section for testing"
        end
      end

      subject { section }

      it { should be_a Section }
      it { should == page.children.last }
      its(:name) { should == "some_section" }
      its(:title) { should == "A Test Section" }
      its(:description) { should == "A section for testing" }
    end

    describe "#tab_set" do
      let :tab_set do
        page.tab_set :some_tab_set, :title => "A Test Tab Set" do
          description "A tab set for testing"
        end
      end

      subject { tab_set }

      it { should be_a TabSet }
      it { should == page.children.last }
      its(:name) { should == "some_tab_set" }
      its(:title) { should == "A Test Tab Set" }
      its(:description) { should == "A tab set for testing" }
    end

    describe "#<=>" do
      it "orders on title" do
        [foo, bar].sort.should == [bar, foo]
      end
    end
  end
end