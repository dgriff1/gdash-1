require "spec_helper"

module GDash
  describe "Index", :type => :feature do
    let!(:foo) { Dashboard.define :foo, :title => "Foo", :description => "Foos" }
    let!(:bar) { Dashboard.define :bar, :title => "Bar", :description => "Bars" }

    let :context do
      Class.new do
        include Helper
      end.new
    end

    let(:template) { Tilt.new(File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. .. lib gdash views index.haml}))) }

    subject { template.render context }

    include Helper

    it { should have_selector "html" }

    context "header" do
      it { should have_selector "head" }
      it { should have_selector "title", :text => "GDash" }

      context "bootstrap" do
        it { should have_selector "link[href='/css/bootstrap.min.css'][rel='stylesheet']" }
        it { should have_selector "script[src='/js/bootstrap.min.js']", :text => "" }
      end

      context "jQuery" do
        it { should have_selector "script[src='/js/jquery-1.8.1.min.js']", :text => "" }
      end
    end

    context "body" do
      context "navbar" do
        it { should have_selector ".navbar.navbar-fixed-top.navbar-inverse" }
        it { should have_selector ".navbar-inner" }

        it { should have_selector "a.brand[href=#{dashboards_path.inspect}]", :text => "GDash" }

        it { should have_selector "ul.nav.pull-right" }
        it { should have_selector "li" }
        it { should have_selector "a[href=#{docs_path.inspect}]", :text => "Documentation" }
      end

      context "main content" do
        it { should have_selector "table.table.table-hover" }

        it { should have_selector "thead" }
        it { should have_selector "th", :text => "Name" }
        it { should have_selector "th", :text => "Description" }

        it { should have_selector "tbody" }
        it { should have_selector "tr" }

        it { should have_selector "a[href=#{dashboard_path(foo).inspect}]", :text => foo.title }
        it { should have_selector "td", :text => foo.description }
        it { should have_selector "a[href=#{dashboard_path(bar).inspect}]", :text => bar.title }
        it { should have_selector "td", :text => bar.description }
      end

      context "footer" do
        let!(:time) { Time.now }
        before { Time.stub! :now => time }

        it { should have_selector ".container-fluid" }
        it { should have_selector "h6" }
        it { should have_content "Updated #{time}" }
      end
    end
  end
end
