require "spec_helper"

module GDash
  describe Window do
    let :window do
      described_class.define :foo, :title => "Foo" do |window|
        window.length = 42
        window.default = true
        window.ganglia_params = { :foo => :bar }
        window.graphite_params = { :baz => :quux }
        window.cacti_params = { :oof => :rab }
      end
    end
    
    subject { window }
    
    its(:name) { should == "foo" }
    its(:title) { should == "Foo" }
    its(:length) { should == 42 }
    its(:default) { should be_true }
    its(:ganglia_params) { should == { :foo => :bar } }
    its(:graphite_params) { should == { :baz => :quux } }
    its(:cacti_params) { should == { :oof => :rab } }

    describe ".define" do
      let!(:foo) { described_class.define :foo }
      subject { described_class }

      context "should register the class" do
        its(:all) { should be_include foo }
      end
      
      context "when there is no default" do
        before { described_class.default = nil }
        let!(:bar) { described_class.define :bar }
        its(:default) { should == bar }
      end
      
      context "when there is a default" do
        before { described_class.default = foo }

        context "and the default option is not set" do
          let!(:bar) { described_class.define :bar }
          its(:default) { should == foo }
        end
        
        context "and the default options is set" do
          let!(:bar) { described_class.define :bar, :default => true }
          its(:default) { should == bar }
        end
      end
    end

    describe ".each" do
      let!(:foo) { described_class.define :foo }
      let!(:bar) { described_class.define :bar }

      it "yields each window" do
        windows = []
        described_class.each do |window|
          windows << window
        end

        windows.should be_include foo
        windows.should be_include bar
      end
    end

    describe "#default" do
      let!(:foo) { described_class.define :foo }
      let!(:bar) { described_class.define :bar, :default => true }
      subject { described_class }
      
      its(:default) { should == bar }
    end

    describe "#length" do
      context "default" do
        subject { described_class.define(:foo).length }
        it { should == 0 }
      end
    end
    
    let!(:time) { Time.now }
    before { Time.stub! :now => time }
    let!(:default_window) { described_class.define(:foo, :length => 10.minutes) }

    describe "#ganglia_params" do
      context "default" do
        subject { default_window.ganglia_params }
        
        its([:cs]) { should == (time - default_window.length).strftime("%m/%d/%Y %H:%M") }
        its([:ce]) { should == time.strftime("%m/%d/%Y %H:%M") }
        
        describe "[:r]" do
          subject { default_window.ganglia_params[:r] }
          
          context "when the title is set" do
            before { default_window.title = "Foo" }
            it { should == "Foo" }
          end
        
          context "when the title is not set" do
            before { default_window.title = nil }
            it { should == "" }
          end
        end
      end
    end

    describe "#graphite_params" do
      context "default" do
        subject { default_window.graphite_params }
        it { should == {} }
      end
    end

    describe "#cacti_params" do
      context "default" do
        subject { default_window.cacti_params }
        
        its([:graph_start]) { should == (time.to_i - default_window.length) }
        its([:graph_end]) { should == time.to_i }
      end
    end

    describe "#to_html" do
      subject { window.to_html }
    end

    describe "#<=>" do
      let(:minute) { described_class.define :foo, :length => 1.minute }
      let(:hour) { described_class.define :bar, :length => 1.hour }
      
      it "compares on length" do
        [hour, minute].sort.should == [minute, hour]
      end
    end
  end
end