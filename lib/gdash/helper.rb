module GDash
  module Helper
    def dashboards_path
      "/"
    end

    def dashboard_path dashboard, options = {}
      params = "?"
      params += "window=#{Rack::Utils.escape(options[:window].name)}" if options.has_key? :window

      "/#{dashboard.name}#{params}"
    end

    def dashboard_nav current = nil
      html = Builder::XmlMarkup.new

      html.div :class => "well" do
        html.ul :class => "nav nav-list" do
          html.li "Dashboards", :class => "nav-header"
          Dashboard.toplevel.sort.each do |dashboard|
            options = {}
            options[:class] = "active" if dashboard == current
            html.li options do
              html.a dashboard.title, { :href => dashboard_path(dashboard) }
            end
          end
        end
      end
    end

    def window_nav dashboard, current = nil
      html = Builder::XmlMarkup.new

      html.ul :class => "nav nav-pills" do
        Window.each do |window|
          options = {}
          options[:class] = "active" if window == current
          html.li options do
            html.a window.title, { :href => dashboard_path(dashboard, :window => window) }
          end
        end
      end
    end
  end
end