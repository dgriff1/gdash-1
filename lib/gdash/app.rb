module GDash
  class App < Sinatra::Base
    use Rack::Session::Cookie, :key => "gdash.session", :secret => Digest::SHA1.hexdigest("gdash.session")
    set :views, File.expand_path(File.join(File.dirname(__FILE__), "views"))
    set :public_folder, File.expand_path(File.join(File.dirname(__FILE__), "public"))

    helpers Helper

    before "/dashboards/*" do
      if params.has_key? "window"
        if params["window"] == "custom" and params.has_key?("start") and params.has_key?("end")
          start = DateTime.parse params["start"]
          stop = DateTime.parse params["end"]
          length = stop.to_i - start.to_i
          @window = Window.new :custom, :start => stop, :length => length.seconds, :title => "Custom"
        else
          @window = Window[params["window"]]
        end
      elsif session.has_key? :window
        @window = session[:window]
      else
        @window = Window.default
      end

      session[:window] = @window
    end

    before "/dashboards/*" do
      @tags = []

      if params.has_key? "tags"
        @tags = params["tags"].split(/[^-_\w\d]+/)
      elsif session.has_key? :tags
        @tags = session[:tags]
      end

      session[:tags] = @tags

      @tag_patterns = @tags.map &Regexp.method(:compile)
    end

    get "/" do
      if Dashboard.toplevel.empty?
        redirect doc_path(Doc.new(:getting_started))
      else
        haml :index, :layout => false
      end
    end

    get "/doc/:filename" do
      @doc = Doc.new(params["filename"])
      erb @doc.to_html, :layout => :doc, :layout_engine => :haml
    end

    get "/doc" do
      redirect doc_path(Doc.new(:getting_started))
    end

    get "/dashboards/:name" do
      @dashboard = Widget[params["name"]]

      if @dashboard
        @dashboard.window = @window
        haml @dashboard.to_html
      end
    end
  end
end