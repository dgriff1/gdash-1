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

    get "/" do
      if Dashboard.all.empty?
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

    get "/dashboards/?*" do
      args = (params[:splat] || [""]).first.split(/\//).reject { |x| x.empty? }

      @dashboard = args.empty? ? Dashboard.all.first : Dashboard[args.shift]
      page = args.empty? ? @dashboard.pages.first : @dashboard.find(args.shift)
      tab_path = args

      if @dashboard
        haml View.new(@dashboard, :window => @window, :page => page, :tab_path => tab_path).to_html
      else
        redirect dashboards_path
      end
    end
  end
end
