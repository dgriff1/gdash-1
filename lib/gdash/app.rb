module GDash
  class App < Sinatra::Base
    set :views, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "views")
    set :public_folder, File.join(File.expand_path(File.dirname(__FILE__)), "../..", "public")

    helpers Helper

    get "/" do
      erb :index
    end

    get "/:name" do
      @dashboard = Dashboard[params["name"].to_sym]

      if @dashboard
        @dashboard.window = params["window"] if params.has_key? "window"
        erb @dashboard.to_html
      end
    end
  end
end