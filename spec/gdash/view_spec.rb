require "spec_helper"

class TestGraph < GDash::Widget
  attr_accessor :title, :foo, :bar

  def title
    @title ||= name.titleize
  end
end

class GDash::View
  def test_graph model, options = {}
    html.div "#{model.title}: foo = #{model.foo.inspect}, bar = #{model.bar.inspect}"
  end
end

module GDash
  describe View, :type => :feature do
    let!(:section_one) do
      GDash.section :test_section_one do |section|
        section.widget :a
        section.widget :b
      end
    end

    let!(:section_two) do
      GDash.section :test_section_two do |section|
        section.widget :c
        section.widget :d
      end
    end

    let!(:model) do
      GDash.dashboard :foo do
        page :first_page do
          tab_set :bar do
            tab :baz do
              section :test_section_one
            end

            tab :quux do
              section :test_section_two

              tab_set :asdf do
                tab :one do
                  section :test_section_one
                end

                tab :two do
                  section :test_section_one
                end
              end
            end
          end
        end

        page :second_page
      end
    end

    let!(:page_one) { model.pages[0] }
    let!(:page_two) { model.pages[1] }
    let!(:tab_set) { page_one.children[0] }
    let!(:tab_one) { tab_set.tabs[0] }
    let!(:tab_two) { tab_set.tabs[1] }

    let!(:tab_three) { tab_two.children[1].tabs[0] }
    let!(:tab_four)  { tab_two.children[1].tabs[1] }

    let!(:view) { View.new model, :window => Window.all.last, :tab_path => [:quux, :one] }

    let!(:html) { view.to_html }

    # before { STDERR.puts html.to_s }

    subject { view }

    its(:model) { should == model }

    describe "#page_nav" do
      subject { view.page_nav model }

      it { should have_selector ".well" }
      it { should have_selector "ul.nav.nav-pills.nav-stacked" }
      it { should have_selector "li.active" }
      it { should have_selector "a[href=#{view.dashboard_path(model, model.pages[0]).inspect}]", :text => model.pages[0].title }
      it { should have_selector "li" }
      it { should have_selector "a[href=#{view.dashboard_path(model, model.pages[1]).inspect}]", :text => model.pages[1].title }
    end

    describe "#dashboard_path" do
      context "with a dashboard" do
        subject { view.dashboard_path model }
        it { should == "/dashboards/foo" }
      end

      context "with a page" do
        subject { view.dashboard_path model, page_one }
        it { should == "/dashboards/foo/first_page" }
      end

      context "with a tab path" do
        subject { view.dashboard_path model, page_one, :bar, :baz }
        it { should == "/dashboards/foo/first_page/bar/baz" }
      end
    end

    describe "#window" do
      subject { view.window }

      pending("works correctly but the test is borked") { should == Window.all.last }

      context "default" do
        subject { View.new(model).window }

        it { should == Window.default }
      end
    end

    describe "#tab_path" do
      subject { view.tab_path }

      it { should == ["quux", "one"] }

      context "default" do
        subject { View.new(model).tab_path }

        it { should == [] }
      end
    end

    describe "#tab_route" do
      subject { view.tab_route }

      it { should == [] }
    end

    describe "#dashboard" do
      subject { html }

      it { should have_selector "#page-nav.well" }
      it { should have_selector "li.active" }
      it { should have_selector "li" }
      it { should have_selector "a[href=#{view.dashboard_path(model, page_one).inspect}]", :text => page_one.title }
      it { should have_selector "a[href=#{view.dashboard_path(model, page_two).inspect}]", :text => page_two.title }
    end

    describe "#page" do
      subject { html }

      it { should have_selector "h1", :text => page_one.title }
      it { should have_selector "br" }
      it { should have_selector "small", :text => page_one.description }
    end

    describe "#tab_set" do
      subject { html }

      it { should have_selector "ul.nav-tabs" }
    end

    describe "#tab" do
      subject { html }

      it { should have_selector "li" }
      it { should have_selector "li.active" }

      it { should have_selector "a[href=#{view.dashboard_path(model, page_one, "baz").inspect}]", :text => tab_one.title }
      it { should have_selector "a[href=#{view.dashboard_path(model, page_one, "quux").inspect}]", :text => tab_two.title }
      it { should have_selector "a[href=#{view.dashboard_path(model, page_one, "quux", "one").inspect}]", :text => tab_three.title }
      it { should have_selector "a[href=#{view.dashboard_path(model, page_one, "quux", "two").inspect}]", :text => tab_four.title }
    end

    describe "#section" do
      let(:section) do
        GDash.section :foo do
          widget :bar
          widget :baz
          widget :quux
        end
      end

      subject { View.new(section).to_html }

      it { should have_selector "div.row-fluid" }
      it { should have_selector "h3", :text => section.title }
      it { should have_selector "table.table" }
      it { should have_selector "tr" }
      it { should have_selector "td" }
    end
  end
end
