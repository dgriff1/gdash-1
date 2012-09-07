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
    end
  end
end