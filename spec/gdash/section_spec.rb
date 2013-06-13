require "spec_helper"

module GDash
  describe Section do
    let :section do
      Section.new :foo do
        title "A Section"
        width 2

        test_widget :a, :foo => "baz" do
          bar "quux"
        end
        test_widget :b
      end
    end
    
    subject { section }

    it { should be_a Base }
    
    its(:title) { should == "A Section" }
    its(:width) { should == 2 }

    describe "#width" do
      context "default" do
        subject { Section.new(:foo).width }
        it { should == 3 }
      end
    end

    describe "#widgets" do
      context "default" do
        subject { Section.new(:foo).widgets }
        it { should == [] }
      end
    end

    describe "#widget" do
      subject { section.widgets }

      its(:length) { should == 2 }

      describe "a" do
        subject { section.widgets[0] }

        it { should be_a TestWidget }
        its(:foo) { should == "baz" }
        its(:bar) { should == "quux" }
      end

      describe "b" do
        subject { section.widgets[1] }

        it { should be_a TestWidget }
      end
    end
  end
end