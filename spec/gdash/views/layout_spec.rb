require "spec_helper"

module GDash
  describe "Layout", :type => :feature do
    let :context do
      Class.new do
        attr_accessor :dashboard, :tags, :data_center
        include Helper
      end.new
    end

    let :data_center do
      Dashboard.define :foo, :title => "A Data Center"
    end
    
    let :dashboard do
      Dashboard.define :foo, :title => "A Dashboard"
    end
    
    let(:template) { Tilt.new(File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. .. lib gdash views layout.haml}))) }
    
    subject do
      template.render context do
        "Page Content"
      end
    end

    before { context.dashboard = dashboard }
    before { context.data_center = data_center }

    include Helper
    
    it { should have_selector "html" }
    
    context "header" do
      it { should have_selector "head" }
      
      context "with a dashboard" do
        it { should have_selector "title", :text => dashboard.title }
        it { should have_selector "meta[http-equiv='refresh'][content=#{dashboard.refresh.to_s.inspect}]" }
      end
      
      context "without a dashboard" do
        before { context.dashboard = nil }
        it { should have_selector "title", :text => "GDash" }
      end
      
      context "bootstrap" do
        it { should have_selector "link[href='/css/bootstrap.min.css'][rel='stylesheet']" }
        it { should have_selector "script[src='/js/bootstrap.min.js']", :text => "" }
      end
      
      context "jQuery" do
        it { should have_selector "script[src='/js/jquery-1.8.1.min.js']", :text => "" }
      end
    end
    
    context "body" do
      it { should have_selector "body[style='padding-top: 50px;']" }
      
      context "navbar" do
        it { should have_selector ".navbar.navbar-fixed-top.navbar-inverse" }
        it { should have_selector ".navbar-inner" }
        
        it { should have_selector "a.brand[href=#{dashboards_path.inspect}]", :text => "GDash" }
        
        it { should have_selector "ul.nav.pull-right" }
        it { should have_selector "li" }
        it { should have_selector "i.icon-share.icon-white" }
        it { should have_selector "li" }
        it { should have_selector "a[href=#{docs_path.inspect}]", :text => "Documentation" }
      end
      
      context "main content" do
        it { should have_selector ".container-fluid" }
        it { should have_selector ".row-fluid" }
        
        context "with a dashboard" do
          it { should have_selector ".span2" }
          it { should have_selector ".span10" }
          it { should have_selector "#dashboard-nav" }
          it { should have_selector "#window-nav" }
          it { should have_content "Page Content" }
        end
        
        context "without a dashboard" do
          before { context.dashboard = nil }
          it { should have_content "Page Content" }
        end
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