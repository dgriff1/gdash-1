require "spec_helper"

module GDash
  describe Section, :type => :feature do
    let :section do
      described_class.new do |section|
        section.title = "A Section"
        section.width = 2
      end
    end
    
    subject { section }

    it { should be_a Widget }
    
    its(:title) { should == "A Section" }
    its(:width) { should == 2 }

    describe "#clone" do
      subject { section.clone }

      its(:name) { should == section.name }
      its(:data_center) { should == section.data_center }
      its(:window) { should == section.window }
      its(:title) { should == section.title }
      its(:width) { should == section.width }
      its(:children) { should == section.children }
    end

    describe "#width" do
      context "default" do
        subject { described_class.new.width }
        it { should == 3 }
      end
    end
    
    describe "#to_html" do
      subject { section.to_html }
      
      it { should have_selector ".row-fluid" }
      it { should have_selector "h2", :text => section.title }
      it { should have_selector "table.table" }
    end
  end
end