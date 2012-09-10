require "spec_helper"

module GDash
  describe GangliaReport do
    subject do
      GangliaReport.new
    end

    it "should be a Ganglia widget" do
      subject.should be_a Ganglia
    end

    describe :report do
      it "should have accessors" do
        subject.report = "Foo"
        subject.report.should == "Foo"
      end
    end

    describe :cluster do
      it "should have accessors" do
        subject.cluster = "Foo"
        subject.cluster.should == "Foo"
      end
    end

    describe :host do
      it "should have accessors" do
        subject.host = "Foo"
        subject.host.should == "Foo"
      end
    end

    describe :to_url do
      subject do
        GangliaReport.new :window => "hour",
                          :size => "xlarge",
                          :title => "The Graph Title",
                          :report => "the_report",
                          :cluster => "The Cluster",
                          :host => "bld-host-01"
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

      it "should include the report" do
        subject.to_url.should =~ /g=#{Rack::Utils.escape(subject.report)}/
      end

      it "should include the host if present" do
        subject.to_url.should =~ /h=#{Rack::Utils.escape(subject.host)}/

        subject.host = nil
        subject.to_url.should_not =~ /h=/
      end

      it "should set the cluster" do
        subject.to_url.should =~ /c=#{Rack::Utils.escape(subject.cluster)}/
      end
    end
  end
end