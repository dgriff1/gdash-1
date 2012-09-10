require "spec_helper"

module GDash
  describe Window do
    subject do
      Window.new :foo
    end

    describe :initialize do
      it "should take a name" do
        Window.new(:foo).name.should == :foo
      end

      it "should take options" do
        window = Window.new(:foo, :title => "Foo", :length => 42)
        window.title.should == "Foo"
        window.length.should == 42
      end

      it "should yield itself to the block" do
        yielded = nil
        window = Window.new :foo do |w|
          yielded = w
        end
        window.should == yielded
      end

      it "should register itself" do
        window = Window.new :foo
        Window.all.include?(window).should be_true
      end

      it "should set itself as default if there is none" do
        Window.default = nil
        window = Window.new :foo
        Window.default.should == window
      end
    end

    describe :each do
      it "should yield each window" do
        window_one = Window.new :foo
        window_two = Window.new :bar

        windows = []
        Window.each do |window|
          windows << window
        end

        windows.include?(window_one).should be_true
        windows.include?(window_two).should be_true
      end
    end

    describe :default do
      it "should have accessors" do
        subject.default = true
        subject.should be_default
      end

      it "should set the class level default" do
        window = Window.new :foo, :default => true
        Window.default.should == window
      end
    end

    describe :name do
      it "should have accessors" do
        subject.name = "Foo"
        subject.name.should == "Foo"
      end
    end

    describe :length do
      it "should have accessors" do
        subject.length = 42
        subject.length.should == 42
      end
    end

    describe :title do
      it "should have a title" do
        subject.title = "The Length"
        subject.title.should == "The Length"
      end
    end

    describe :ganglia_params do
      it "should have accessors" do
        subject.ganglia_params = { :foo => :bar }
        subject.ganglia_params.should == { :foo => :bar }
      end

      it "should default to an empty hash" do
        subject.ganglia_params.should == {}
      end
    end

    describe :graphite_params do
      it "should have accessors" do
        subject.graphite_params = { :foo => :bar }
        subject.graphite_params.should == { :foo => :bar }
      end

      it "should default to an empty hash" do
        subject.graphite_params.should == {}
      end
    end

    describe :cacti_params do
      it "should have accessors" do
        subject.cacti_params = { :foo => :bar }
        subject.cacti_params.should == { :foo => :bar }
      end

      it "should default to an empty hash" do
        subject.cacti_params.should == {}
      end
    end

    describe :<=> do
      it "should compare on length" do
        minute = Window.new :foo, :length => 1.minute
        hour = Window.new :bar, :length => 1.hour
        [hour, minute].sort.should == [minute, hour]
      end
    end
  end
end