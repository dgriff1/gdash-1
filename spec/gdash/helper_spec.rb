require "spec_helper"

GDash::Dashboard.define :foo, :title => "Foobar" do |dashboard|
  dashboard.dashboard :bar, :title => "BarBar"
end

GDash::Dashboard.define :baz, :title => "All About Baz"

module GDash
  describe Helper do
    subject do
      klass = Class.new.send :include, Helper
      klass.new
    end

    describe :dashboards_path do
      it "should generate /" do
        subject.dashboards_path.should == "/"
      end
    end

    describe :dashboard_path do
      it "should generate /:name" do
        subject.dashboard_path(Dashboard[:foo]).should == "/foo?"
      end

      it "should take a window option" do
        subject.dashboard_path(Dashboard[:foo], :window => Window.new(:foo)).should == "/foo?window=foo"
      end
    end

    describe :docs_path do
      it "should generate /doc" do
        subject.docs_path.should == "/doc"
      end
    end

    describe :doc_path do
      it "should generate /doc/:filename" do
        subject.doc_path(Doc.new(:getting_started)).should == "/doc/getting_started"
      end
    end

    describe :dashbaord_nav do
      before do
        @html = subject.dashboard_nav
      end

      it "should be in a well" do
        @html.should =~ /<div class="well">.*<\/div>/m
      end

      it "should have a nav list" do
        @html.should =~ /<ul class="nav nav-list">.*<\/ul>/m
      end

      it "should have a header" do
        @html.should =~ /<li class="nav-header">Dashboards<\/li>/
      end

      it "should have links for each toplevel dashboard" do
        Dashboard.toplevel.each do |dashboard|
          @html.should =~ /<li>
                           \s*
                           <a href="#{subject.dashboard_path(dashboard)}">
                           \s*
                           #{dashboard.title}
                           \s*
                           <\/a>
                           \s*
                           <\/li>/mx
        end
      end

      it "should have links for each dashboard" do
        Dashboard.each do |dashboard|
          @html.should =~ /<li>
                           \s*
                           <a href="#{subject.dashboard_path(dashboard)}">
                           \s*
                           #{dashboard.title}
                           \s*
                           <\/a>
                           \s*
                           <\/li>/mx
        end
      end

      it "should have an active for the current dashboard" do
        dashboard = Dashboard[:foo]
        subject.dashboard_nav(dashboard).should =~ /<li>
                                                    \s*
                                                    <a class="active" href="#{subject.dashboard_path(dashboard)}">
                                                    \s*
                                                    #{dashboard.title}
                                                    \s*
                                                    <\/a>
                                                    \s*
                                                    <\/li>/mx
      end
    end

    describe :window_nav do
      before do
        @dashboard = Dashboard[:foo]
        @html = subject.window_nav @dashboard
      end

      it "should have a nav list" do
        @html.should =~ /<ul class="nav nav-pills">.*<\/ul>/m
      end

      it "should have links for each window" do
        Window.each do |window|
          @html.should =~ /<li>
                           \s*
                           <a href="#{subject.dashboard_path(@dashboard, :window => window)}">
                           \s*
                           #{window.title}
                           \s*
                           <\/a>
                           \s*
                           <\/li>/mx
        end
      end

      it "should have an active for the current window" do
        window = Window.all.first
        subject.window_nav(dashboard, window).should =~ /<li>
                                                         \s*
                                                         <a class="active" href="#{subject.dashboard_path(dashboard, window)}">
                                                         \s*
                                                         #{window.title}
                                                         \s*
                                                         <\/a>
                                                         \s*
                                                         <\/li>/mx
      end
    end

    describe :doc_nav do
      before do
        @html = subject.doc_nav
      end

      it "should be in a well" do
        @html.should =~ /<div class="well">.*<\/div>/m
      end

      it "should have a nav list" do
        @html.should =~ /<ul class="nav nav-list">.*<\/ul>/m
      end

      it "should have a header" do
        @html.should =~ /<li class="nav-header">Pages<\/li>/
      end

      it "should have links for each documentation page" do
        Doc.each do |doc|
          @html.should =~ /<li>
                           \s*
                           <a href="#{subject.doc_path(doc)}">
                           \s*
                           #{doc.title}
                           \s*
                           <\/a>
                           \s*
                           <\/li>/mx
        end
      end

      it "should have an active for the current dashboard" do
        subject.doc_nav(:getting_started).should =~ /<li>
                                                     \s*
                                                     <a class="active" href="#{subject.doc_path(:getting_started)}">
                                                     \s*
                                                     Getting Started
                                                     \s*
                                                     <\/a>
                                                     \s*
                                                     <\/li>/mx
      end
    end
  end
end