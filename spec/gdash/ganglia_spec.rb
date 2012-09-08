require "spec_helper"

module GDash
  describe Ganglia do
    subject do
      Ganglia.new
    end

    it "should be a widget" do
      subject.should be_a Widget
    end

    describe :window do
      it "should have an accessor" do
        subject.window = "2hr"
        subject.window.should == "2hr"
      end

      it "should default to an hour" do
        subject.window.should == "hour"
      end

      it "should validate that it is in Ganglia::WINDOWS" do
        Ganglia::WINDOWS.values.each do |window|
          lambda { subject.window = window }.should_not raise_error
        end

        lambda { subject.window = :foobar }.should raise_error
      end
    end

    describe :size do
      it "should have an accessor" do
        subject.size = "xlarge"
        subject.size.should == "xlarge"
      end

      it "should default to medium" do
        subject.size.should == "large"
      end

      it "should validate that it is in Ganglia::SIZES" do
        Ganglia::SIZES.each do |size|
          lambda { subject.size = size }.should_not raise_error
        end

        lambda { subject.size = :foobar }.should raise_error
      end
    end

    describe :title do
      it "should have an accessor" do
        subject.title = "Foo"
        subject.title.should == "Foo"
      end
    end

    describe :embed do
      it "should have an accessor" do
        subject.embed = false
        subject.embed.should be_false
      end

      it "should default to true" do
        subject.embed.should == true
      end
    end

    describe :to_url do
      subject do
        Ganglia.new :window => "hour",
                    :size => "xlarge",
                    :title => "The Graph Title",
                    :embed => true
      end

      it "should include the window" do
        subject.to_url.should =~ /r=#{Rack::Utils.escape(subject.window)}/
      end

      it "should include the size" do
        subject.to_url.should =~ /z=#{Rack::Utils.escape(subject.size)}/
      end

      it "should include the title" do
        subject.to_url.should =~ /title=#{Rack::Utils.escape(subject.title)}/
      end

      it "should include the embed" do
        subject.to_url.should =~ /embed=1/
      end
    end

    describe :to_html do
      it "should create an image with the ganglia graph" do
        subject.to_html.should == "<img src=\"#{subject.to_url}\"/>"
      end
    end
  end
end