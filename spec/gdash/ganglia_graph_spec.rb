require "spec_helper"

module GDash
  describe GangliaGraph do
    subject do
      GangliaGraph.new
    end

    it "should be a Ganglia widget" do
      subject.should be_a Ganglia
    end

    describe :hosts do
      it "should have an accessor" do
        subject.hosts = "Foo"
        subject.hosts.should == "Foo"
      end
    end

    describe :metrics do
      it "should have an accessor" do
        subject.metrics = "Foo"
        subject.metrics.should == "Foo"
      end
    end

    describe :vertical_label do
      it "should have an accessor" do
        subject.vertical_label = "Foo"
        subject.vertical_label.should == "Foo"
      end
    end

    describe :upper_limit do
      it "should have an accessor" do
        subject.upper_limit = 42
        subject.upper_limit.should == 42
      end
    end

    describe :lower_limit do
      it "should have an accessor" do
        subject.lower_limit = 42
        subject.lower_limit.should == 42
      end
    end

    describe :limits= do
      it "should set the upper and lower limit" do
        subject.limits = (1..10)
        subject.lower_limit.should == 1
        subject.upper_limit.should == 10
      end
    end

    describe :type do
      it "should have an accessor" do
        subject.type = "Foo"
        subject.type.should == "Foo"
      end
    end

    describe :legend do
      it "should have an accessor" do
        subject.legend = true
        subject.legend.should be_true
      end
    end

    describe :aggregate do
      it "should have an accessor" do
        subject.aggregate = false
        subject.aggregate.should be_false
      end

      it "should default to true" do
        subject.aggregate.should == true
      end
    end

    describe :to_url do
      subject do
        GangliaGraph.new :window => Window.new(:hour, :length => 1.hour),
                         :size => "xlarge",
                         :title => "The Graph Title",
                         :vertical_label => "A Label",
                         :limits => (1..10),
                         :hosts => "bld-host-0[123]",
                         :metrics => "metric.name.[\\d]",
                         :type => "stacked",
                         :legend => true,
                         :aggregate => true
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

      it "should include the vertical label" do
        subject.to_url.should =~ /vl=#{Rack::Utils.escape(subject.vertical_label)}/
      end

      it "should set the limits" do
        subject.to_url.should =~ /x=#{Rack::Utils.escape(subject.upper_limit)}/
        subject.to_url.should =~ /n=#{Rack::Utils.escape(subject.lower_limit)}/
      end

      it "should set the host regular expression" do
        subject.to_url.should =~ /hreg\[\]=#{Rack::Utils.escape(subject.hosts)}/
      end

      it "should set the metrics regular expression" do
        subject.to_url.should =~ /mreg\[\]=#{Rack::Utils.escape(subject.metrics)}/
      end

      it "should set the graph type" do
        subject.to_url.should =~ /gtype=#{Rack::Utils.escape(subject.type)}/
      end

      it "should set the legend" do
        subject.to_url.should =~ /glegend=#{Rack::Utils.escape(subject.legend)}/
      end

      it "should set the aggregate" do
        subject.to_url.should =~ /aggregate=1/
      end
    end
  end
end