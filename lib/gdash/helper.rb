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
            html.li do
              options = { :href => dashboard_path(dashboard) }
              options[:class] = "active" if dashboard == current
              html.a dashboard.title, options
            end
          end
        end
      end
    end

    def window_nav dashboard, current = nil
      html = Builder::XmlMarkup.new

      html.div :class => "well" do
        html.ul :class => "nav nav-list" do
          html.li "Time Window", :class => "nav-header"
          Window.each do |window|
            html.li do
              options = { :href => dashboard_path(dashboard, :window => window) }
              options[:class] = "active" if window == current
              html.a window.title, options
            end
          end
        end
      end
    end
  end
end