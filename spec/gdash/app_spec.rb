require "spec_helper"


module GDash
  describe App do
    include Rack::Test::Methods

    let!(:dashboard) { GDash::Dashboard.toplevel :foo }

    describe "Root" do
      subject { get "/" }

      context "when dashboards are defined" do
        it { should be_ok }
        its(:body) { should_not be_empty }
      end

      context "when no dashboards are defined" do
        before { GDash::Dashboard.stub! :toplevel => [] }
        it { should be_redirect }
      end
    end

    describe "Showing a dashboard" do
      describe "when :name is a defined dashbaord" do
        subject { get "/foo" }

        it { should be_ok }
        its(:body) { should =~ /#{Dashboard[:foo].to_html}/ }
      end
      
      describe :window do
        let!(:foo) { Window.define :foo }
        let!(:bar) { Window.define :bar }

        it "looks up the window" do
          get "/foo?window=foo"
          dashboard.window.should == Window[:foo]
        end
        
        it "uses the default window if not specified" do
          get "/foo"
          dashboard.window.should == Window.default
        end
      end
    end

    describe "Documentation" do
      subject { get "/doc" }
      it { should be_redirect }
    end

    describe "Showing a help page" do
      describe "when :page exists" do
        before do
          File.open File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. doc foo.md})), "w" do |f|
            f.puts "# Test"
          end
        end
        after { File.unlink File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. doc foo.md})) }
        
        subject { get "/doc/foo" }

        it { should be_ok }
        its(:body) { should =~ /<h1>\s*Test\s*<\/h1>/m }
      end
    end
  end
end