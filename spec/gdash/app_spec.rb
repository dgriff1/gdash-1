require "spec_helper"

GDash::Dashboard.new :foo do
end

GDash::Dashboard.new :bar do
end

module GDash
  describe App do
    include Rack::Test::Methods

    describe "/:name" do
      describe "when :name is a defined dashbaord" do
        before do
          get "/foo"
        end

        it "should return a 200 OK" do
          last_response.should be_ok
        end

        it "should return the dashboard" do
          last_response.body.should =~ /#{Dashboard[:foo].to_html}/
        end
      end
      
      describe :window do
        before do
          Window.define :foo
          Window.define :bar

          @dashboard = Dashboard.new :foo
          Dashboard.stub! :new => @dashboard
        end
        
        it "should look up the window" do
          get "/foo?window=foo"
          @dashboard.window.should == Window[:foo]
        end
        
        it "should use the default window if not specified" do
          get "/foo"
          @dashboard.window.should == Window.default
        end
      end
    end

    describe "/doc" do
      it "should redirect" do
        get "/doc"
        last_response.should be_redirect
      end
    end

    describe "/doc/:page" do
      describe "when :page exists" do
        before do
          File.open File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. doc foo.md})), "w" do |f|
            f.puts "# Test"
          end
          get "/doc/foo"
        end

        after do
          File.unlink File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. doc foo.md}))
        end

        it "should return a 200 OK" do
          last_response.should be_ok
        end

        it "should render the file as markdown" do
          last_response.body.should =~ /<h1>\s*Test\s*<\/h1>/m
        end
      end
    end
  end
end