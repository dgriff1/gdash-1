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
        subject.rrd_id = "Foo"
        subject.rrd_id.should == "Foo"
      end
    end

    describe :to_html do
      it "should be an image" do
        subject.to_html.should =~ /<img src="#{subject.to_html}"\/>/
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

      it "should have the RRD id" do
        subject.to_url.should =~ /rrd_id=#{Rack::Utils.escape(subject.rrd_id)}/
      end
    end
  end
end