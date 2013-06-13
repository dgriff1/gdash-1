require "spec_helper"


module GDash
  describe Helper, :type => :feature do
    before do
      Dashboard.instance_variable_set :@dashboards, nil
    end

    let! :data_center_one do
      DataCenter.define :data_center_one, :title => "Foo"
    end
    
    let! :data_center_two do
      DataCenter.define :data_center_two, :title => "Bar"
    end
        
    let! :foo do
      GDash.dashboard :foo, :title => "Foobar" do
        # dashboard.dashboard :bar, :title => "BarBar"
        # dashboard.data_center = data_center_one
      end
    end
    
    let! :baz do
      GDash.dashboard :baz, :title => "All About Baz" do
        # baz.data_center = data_center_two

        custom_window :my_window do
          length 42.minutes
          title "My Time Window"
        end
      end
    end
    
    let(:getting_started) { Doc.new(:getting_started) }
    
    let(:window) { GDash.window :window }
    
    let :helper do
      Class.new do
        include Helper
      end.new
    end

    subject { helper }

    describe "#dashboards_path" do
      subject { helper.dashboards_path }
      it { should == "/" }
    end
    

    describe "#dashboard_path" do
      context "without a window" do
        subject { helper.dashboard_path foo }
        it { should == "/dashboards/foo" }
      end

      context "with a window" do
        subject { helper.dashboard_path foo, :window => window }
        it { should == "/dashboards/foo?window=window" }
      end

      context "with a custom window" do
        let(:window) { Window.new :custom, :start => DateTime.parse("2012-01-01 01:00:00"), :length => 3600.seconds }
        subject { helper.dashboard_path foo, :window => window }
        it { should == "/dashboards/foo?window=custom&end=#{Rack::Utils.escape("2012-01-01 01:00:00")}&start=#{Rack::Utils.escape("2012-01-01 00:00:00")}" }
      end

      context "with a tab path" do
        subject { helper.dashboard_path foo, :tab_path => [:bar, :baz, :quux] }
        it { should == "/dashboards/foo/bar/baz/quux" }
      end

      context "with all the options" do
        subject { helper.dashboard_path foo, :window => window, :tab_path => [:bar, :baz, :quux] }
        it { should == "/dashboards/foo/bar/baz/quux?window=window" }
      end
    end

    describe "#docs_path" do

      subject { helper.docs_path }
      it { should == "/doc" }
    end

    describe "#doc_path" do
      subject { helper.doc_path getting_started }
      it { should == "/doc/getting_started" }
    end

    describe "#dashbaord_nav" do
      subject { helper.dashboard_nav foo }

      it { should have_selector ".well" }
      it { should have_selector "ul.nav.nav-pills.nav-stacked" }
      it { should have_selector "li.nav-header", :text => "Dashboards" }
      it { should have_selector "li.active" }
      it { should have_selector "a[href=#{helper.dashboard_path(foo).inspect}]", :text => foo.title }
      it { should have_selector "li" }
      it { should have_selector "a[href=#{helper.dashboard_path(baz).inspect}]", :text => baz.title }

      context "with window" do
        subject { helper.dashboard_nav foo, :window => Window.all.last }

        it { should have_selector "div#dashboard-nav.well" }
        it { should have_selector "ul.nav.nav-pills.nav-stacked" }
        it { should have_selector "li.nav-header", :text => "Dashboards" }
        it { should have_selector "li.active" }
        it { should have_selector "a[href=#{helper.dashboard_path(foo, :window => Window.all.last).inspect}]", :text => foo.title }
        it { should have_selector "li" }
        it { should have_selector "a[href=#{helper.dashboard_path(baz, :window => Window.all.last).inspect}]", :text => baz.title }
      end
    end

    describe "#window_nav" do
      subject { helper.window_nav foo, :window => Window.all.last, :tab_path => [:bar, :baz, :quux] }

      it { should have_selector "ul#window-nav.nav.nav-pills" }
      it { should have_selector "li.nav-header", :text => "Time Window" }

      Window.each do |window|
        it { should have_selector "li" }
        it { should have_selector "a[href=#{helper.dashboard_path(foo, :window => window, :tab_path => [:bar, :baz, :quux]).inspect}]", :text => window.title }
      end

      it { should have_selector "li.active" }
    end

    describe "#doc_nav" do
      subject { helper.doc_nav }

      it { should have_selector ".well" }
      it { should have_selector "ul.nav.nav-list" }
      it { should have_selector "li.nav-header", :text => "Pages" }
      it { should have_selector "a[href='/doc/getting_started']", :text => "Getting Started" }

      context "with a current page" do
        subject { helper.doc_nav getting_started }
        it { should have_selector "li.active" }
      end
    end
  end
end