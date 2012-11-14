require "spec_helper"


module GDash
  describe Helper, :type => :request do
    before do
      Dashboard.instance_variable_set :@dashboards, nil
      Dashboard.instance_variable_set :@toplevel, nil
    end
    
    let! :foo do
      Dashboard.toplevel :foo, :title => "Foobar" do |dashboard|
        dashboard.dashboard :bar, :title => "BarBar"
      end
    end
    
    let! :baz do
      Dashboard.toplevel :baz, :title => "All About Baz" do |baz|
        baz.custom_window :custom_window do |window|
          window.length = 42.minutes
          window.title = "Custom Time Window"
        end
      end
    end
    
    let(:getting_started) { Doc.new(:getting_started) }
    
    let(:window) { Window.new :a_window }
    
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
        it { should == "/dashboards/foo?" }
      end

      context "with a window" do
        subject { helper.dashboard_path foo, :window => window }
        it { should == "/dashboards/foo?window=a_window" }
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
      subject { helper.dashboard_nav }

      it { should have_selector "ul.nav.nav-list" }
      it { should have_selector "li.nav-header", :content => "Dashboards" }
      it { should have_selector "a", :href => "/dashboards/foo", :content => "Foobar" }
      it { should have_selector "a", :href => "/dashboards/bar", :content => "BarBar" }
      it { should have_selector "a", :href => "/dashboards/baz", :content => "All About Baz" }

      context "with a current dashboard" do
        subject { helper.dashboard_nav(foo) }
        it { should have_selector "li.active" }
      end
    end

    describe "#window_nav" do
      subject { helper.window_nav foo }

      it { should have_selector "ul.nav.nav-pills" }
      
      it { should have_selector "a", :href => "/dashboards/foo?window=one_hour", :content => "1 Hour" }
      it { should have_selector "a", :href => "/dashboards/foo?window=two_hours", :content => "2 Hours" }
      it { should have_selector "a", :href => "/dashboards/foo?window=four_hours", :content => "4 Hours" }
      it { should have_selector "a", :href => "/dashboards/foo?window=twelve_hours", :content => "12 Hours" }
      it { should have_selector "a", :href => "/dashboards/foo?window=one_day", :content => "1 Day" }
      it { should have_selector "a", :href => "/dashboards/foo?window=two_days", :content => "2 Days" }
      it { should have_selector "a", :href => "/dashboards/foo?window=one_week", :content => "1 Hour" }
      it { should have_selector "a", :href => "/dashboards/foo?window=two_weeks", :content => "2 Weeks" }
      it { should have_selector "a", :href => "/dashboards/foo?window=one_month", :content => "Month" }
      it { should have_selector "a", :href => "/dashboards/foo?window=one_year", :content => "Year" }

      context "with a current window" do
        subject { helper.window_nav foo, Window.all.first }
        it { should have_selector "li.active" }
      end

      context "with a custom window" do
        subject { helper.window_nav baz }
        it { should have_selector "a", :href => "/dashboards/baz?window=custom_window", :content => "Custom Time Window" }
      end
    end

    describe "#doc_nav" do
      subject { helper.doc_nav }

      it { should have_selector ".well" }
      it { should have_selector "ul.nav.nav-list" }
      it { should have_selector "li.nav-header", :content => "Pages" }
      it { should have_selector "a", :href => "/doc/getting_started", :content => "Getting Started" }

      context "with a current page" do
        subject { helper.doc_nav getting_started }
        it { should have_selector "li.active" }
      end
    end
  end
end