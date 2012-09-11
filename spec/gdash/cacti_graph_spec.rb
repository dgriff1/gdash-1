require "spec_helper"

module GDash
  describe CactiGraph do
    subject do
      CactiGraph.new
    end

    it "should be a Widget" do
      subject.should be_a Widget
    end

    describe :graph_id do
      it "should have accessors" do
        subject.graph_id = "Foo"
        subject.graph_id.should == "Foo"
      end
    end

    describe :rrd_id do
      it "should have accessors" do
        subject.rra_id = "Foo"
        subject.rra_id.should == "Foo"
      end
    end

    describe :to_html do
      it "should be an image" do
        subject.to_html.should =~ /<img src="#{Regexp.escape subject.to_url}"\/>/
      end
    end

    describe :to_url do
      subject do
        CactiGraph.new :cacti_host => "https://cacti-host/path/to/cacti"
      end

      it "should include the cacti host" do
        subject.to_url.should =~ /https:\/\/cacti-host\/path\/to\/cacti\/graph_image.php\?/
      end

      it "should have the action" do
        subject.to_url.should =~ /action=view/
      end

      it "should have the local graph id" do
        subject.to_url.should =~ /local_graph_id=#{Rack::Utils.escape(subject.graph_id)}/
      end

      it "should have the RRA id" do
        subject.to_url.should =~ /rra_id=#{Rack::Utils.escape(subject.rra_id)}/
      end

      it "should have the window cacti_params" do
        window = Window.new :foo do |w|
          w.cacti_params = { :foo => :bar, :baz => :quux }
        end
        subject.window = window
        subject.to_url.should =~ /foo=bar/
        subject.to_url.should =~ /baz=quux/
      end
    end
  end
end