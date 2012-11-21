require "spec_helper"


module GDash
  describe Helper, :type => :feature do
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
        baz.custom_window :my_window do |window|
          window.length = 42.minutes
          window.title = "My Time Window"
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
        it { should == "/dashboards/foo" }
      end

      context "with a window" do
        subject { helper.dashboard_path foo, :window => window }
        it { should == "/dashboards/foo?window=a_window" }
      end

      context "with a custom window" do
        let(:window) { Window.new :custom, :start => DateTime.parse("2012-01-01 01:00:00"), :length => 3600.seconds }
        subject { helper.dashboard_path foo, :window => window }
        it { should == "/dashboards/foo?window=custom&end=#{Rack::Utils.escape("2012-01-01 01:00:00")}&start=#{Rack::Utils.escape("2012-01-01 00:00:00")}" }
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

      it { should have_selector "ul.dropdown-menu[role='menu'][aria-labelledby='dropdownMenu']" }
      it { should have_selector "li" }
      it { should have_selector "a[href=#{helper.dashboard_path(Dashboard[:foo], :window => Window.default).inspect}]", :text => "Foobar" }
      it { should have_selector "a[href=#{helper.dashboard_path(Dashboard[:bar], :window => Window.default).inspect}]", :text => "BarBar" }
      it { should have_selector "a[href=#{helper.dashboard_path(Dashboard[:baz], :window => Window.default).inspect}]", :text => "All About Baz" }
    end

    describe "#window_nav" do
      subject { helper.window_nav foo }

      it { should have_selector "ul.dropdown-menu[role='menu'][aria-labelledby='dropdownMenu']" }
      
      it { should have_selector "a[href='/dashboards/foo?window=one_hour']", :text => "Hour" }
      it { should have_selector "a[href='/dashboards/foo?window=two_hours']", :text => "2 Hours" }
      it { should have_selector "a[href='/dashboards/foo?window=four_hours']", :text => "4 Hours" }
      it { should have_selector "a[href='/dashboards/foo?window=twelve_hours']", :text => "12 Hours" }
      it { should have_selector "a[href='/dashboards/foo?window=one_day']", :text => "Day" }
      it { should have_selector "a[href='/dashboards/foo?window=two_days']", :text => "2 Days" }
      it { should have_selector "a[href='/dashboards/foo?window=one_week']", :text => "Week" }
      it { should have_selector "a[href='/dashboards/foo?window=two_weeks']", :text => "2 Weeks" }
      it { should have_selector "a[href='/dashboards/foo?window=one_month']", :text => "Month" }
      it { should have_selector "a[href='/dashboards/foo?window=one_year']", :text => "Year" }

      context "with a custom window" do
        subject { helper.window_nav baz }
        it { should have_selector "a[href='/dashboards/baz?window=my_window']", :text => "My Time Window" }
      end

      context "with live window" do
        subject { helper.window_nav foo }
        it { should have_selector "a.dropdown-toggle[href='#'][data-toggle='dropdown']", :text => "Custom" }
      end

      context "custom window dropdown" do
        subject { helper.window_nav foo }
        it { should have_selector "li.dropdown-submenu" }
        it { should have_selector "a.dropdown-toggle[data-toggle='dropdown']" }
        it { should have_selector ".dropdown-menu" }
        it { should have_selector "form[action=#{helper.dashboard_path(foo).inspect}][method='get']" }
        it { should have_selector "legend", :text => "Custom Time Window" }
        it { should have_selector "input#window[type='hidden'][value='custom']" }
        it { should have_selector "label[for='start']", :text => "Start" }
        it { should have_selector "input#start[type='text']" }
        it { should have_selector "label[for='end']", :text => "End" }
        it { should have_selector "input#end[type='text']" }
        it { should have_selector "input[type='submit'][value='Go!']" }
      end
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