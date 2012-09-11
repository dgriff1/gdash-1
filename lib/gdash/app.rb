module GDash
  class App < Sinatra::Base
    set :views, File.expand_path(File.join(File.dirname(__FILE__), "../..", "views"))
    set :public_folder, File.expand_path(File.join(File.dirname(__FILE__), "../..", "public"))

    helpers Helper

    get "/" do
      haml :index, :layout => false
    end

    get "/doc/:filename" do
      @doc = Doc.new(params["filename"])
      haml @doc.to_html, :layout => :doc
    end

    get "/doc" do
      redirect doc_path(Doc.new(:getting_started))
    end

    get "/:name" do
      @dashboard = Dashboard[params["name"].to_sym]

      if @dashboard
        @dashboard.window = Window[params["window"].to_sym] if params.has_key? "window"
        haml @dashboard.to_html
      end
    end
  end
end