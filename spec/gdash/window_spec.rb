require "spec_helper"

module GDash
  describe Window do
    before do
      @now = DateTime.now
      DateTime.stub! :now => @now
    end

    let :window do
      GDash.window :foo, :title => "Foo" do
        length 42
        default true
        ganglia_params :foo => :bar
        graphite_params :baz => :quux
        cacti_params :oof => :rab
      end
    end
    
    subject { window }

    it { should be_a Base }
    
    its(:name) { should == "foo" }
    its(:title) { should == "Foo" }
    its(:start) { should == @now }
    its(:length) { should == 42 }
    its(:default) { should be_true }
    its(:ganglia_params) { should == { :foo => :bar } }
    its(:graphite_params) { should == { :baz => :quux } }
    its(:cacti_params) { should == { :oof => :rab } }

    describe ".default" do
      let!(:foo) { GDash.window :foo }
      let!(:bar) { GDash.window :bar, :default => true }
      subject { Window }
      
      its(:default) { should == bar }
    end

    describe "#start" do
      context "default" do
        subject { Window.new(:foo).start }
        it { should == @now }
      end
    end

    describe "#length" do
      context "default" do
        subject { Window.new(:foo).length }
        it { should == 0 }
      end
    end
    
    let!(:time) { Time.now }
    before { Time.stub! :now => time }
    let!(:default_window) { GDash.window(:foo, :length => 10.minutes) }

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
      let(:minute) { GDash.window :foo, :length => 1.minute }
      let(:hour) { GDash.window :bar, :length => 1.hour }
      
      it "compares on length" do
        [hour, minute].sort.should == [minute, hour]
      end
    end
  end
end