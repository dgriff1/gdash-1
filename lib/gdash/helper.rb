module GDash
  module Helper
    def dashboards_path
      "/"
    end

    def dashboard_path dashboard, options = {}
      params = nil
      tab_path = nil

      if options[:window]
        params = { :window => options[:window].name }

        if options[:window].name == "custom"
          params[:end] = options[:window].start.strftime("%Y-%m-%d %H:%M:%S")
          params[:start] = (options[:window].start - options[:window].length.seconds).strftime("%Y-%m-%d %H:%M:%S")
        end
      end

      if options[:tab_path]
        tab_path = "/" + options[:tab_path].map(&:to_s).join("/")
      end

      params = "?" + params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&") if params.present?

      "/dashboards/#{dashboard.name}#{tab_path}#{params}"
    end

    def docs_path
      "/doc"
    end

    def doc_path doc
      "/doc/#{Rack::Utils.escape(doc.name)}"
    end

    def dashboard_nav current = nil, options = {}
      title = current.nil? ? "Dashboards" : current.title
      current ||= Dashboard.all.first
      html ||= Builder::XmlMarkup.new

      html.a :class => "dropdown-toggle", :href => "#", :"data-toggle" => "dropdown" do
        html.text! title
        html.b :class => "caret" do
        end
      end

      html.ul :class => "dropdown-menu", :role => "menu", :"aria-labelledby" => "dropdownMenu" do
        Dashboard.all.each do |dashboard|
          html.li do
            html.a dashboard.title, :href => "/dashboards/#{dashboard.name}"
          end
        end
      end
    end

    def window_nav dashboard, options = {}
      html = Builder::XmlMarkup.new
      options[:window] ||= Window.default

      html.ul :id => "window-nav", :class => "nav nav-pills" do
        html.li "Time Window", :class => "nav-header"
        dashboard.windows.each do |window|
          if window.name == options[:window].name
            html.li :class => "active" do
              html.a window.title, :href => dashboard_path(dashboard, options.merge(:window => window))
            end
          else
            html.li do
              html.a window.title, :href => dashboard_path(dashboard, options.merge(:window => window))
            end
          end
        end
      end
    end

    def doc_nav current = nil
      html = Builder::XmlMarkup.new

      html.div :class => "well" do
        html.ul :class => "nav nav-list" do
          html.li "Pages", :class => "nav-header"
          Doc.each do |doc|
            options = {}
            options[:class] = "active" if doc == current
            html.li options do
              html.a doc.title, :href => doc_path(doc)
            end
          end
        end
      end
    end
  end
end
