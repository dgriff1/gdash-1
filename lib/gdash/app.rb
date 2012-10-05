module GDash
  class App < Sinatra::Base
    set :views, File.expand_path(File.join(File.dirname(__FILE__), "views"))
    set :public_folder, File.expand_path(File.join(File.dirname(__FILE__), "public"))

    helpers Helper

    get "/" do
      haml :index, :layout => false
    end

    get "/doc/:filename" do
      @doc = Doc.new(params["filename"])
      erb @doc.to_html, :layout => :doc, :layout_engine => :haml
    end

    get "/doc" do
      redirect doc_path(Doc.new(:getting_started))
    end

    get "/:name" do
      @dashboard = Dashboard[params["name"].to_sym]

      if @dashboard
        @dashboard.window = params.has_key?("window") ? Window[params["window"].to_sym] : Window.default
        haml @dashboard.to_html
      end
    end
  end
end