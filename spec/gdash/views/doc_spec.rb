require "spec_helper"

module GDash
  describe "Doc", :type => :feature do
    let :context do
      Class.new do
        include Helper
      end.new
    end
    
    let(:template) { Tilt.new(File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. .. lib gdash views doc.haml}))) }
    
    subject do
      template.render context do
        "Page Content"
      end
    end
    
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
      it { should have_selector "body[style='padding-top: 50px;']" }
      
      context "navbar" do
        it { should have_selector ".navbar.navbar-fixed-top.navbar-inverse" }
        it { should have_selector ".navbar-inner" }
        
        it { should have_selector "a.brand[href=#{dashboards_path.inspect}]", :text => "GDash" }
        
        it { should have_selector "ul.nav" }
        it { should have_selector "li.dropdown" }
        it { should have_selector "a.dropdown-toggle[href='#'][data-toggle='dropdown']", :text => "Dashboards" }
        it { should have_selector "b.caret", :text => "" }
        it { should have_selector "li.dropdown" }
        it { should have_selector "a.dropdown-toggle[href='#'][data-toggle='dropdown']" }
        it { should have_selector "b.caret", :text => "" }
        it { should have_selector "li.dropdown" }
        it { should have_selector "a.dropdown-toggle[href='#'][data-toggle='dropdown']", :text => "Data Center" }
        it { should have_selector "b.caret", :text => "" }
        it { should have_selector "li" }
        it { should have_selector "form.navbar-search" }
        it { should have_selector "input.search-query[name='tags'][type='text'][placeholder='Filter']" }
        it { should have_selector "ul.nav.pull-right" }
        it { should have_selector "li" }
        it { should have_selector "a[href=#{docs_path.inspect}]", :text => "Documentation" }
      end
      
      context "main content" do
        it { should have_selector ".container-fluid" }
        it { should have_selector ".row-fluid" }
        
        it { should have_selector ".span2" }
        it { should =~ Regexp.compile(Regexp.escape(doc_nav)) }
        
        it { should have_selector ".span10"}
        it { should have_content "Page Content" }
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