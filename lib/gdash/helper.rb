module GDash
  module UrlHelper
    def dashboards_path
      "/"
    end

    def dashboard_path dashboard, options = nil
      if options
        options = options.map do |k, v|
          "#{k}=#{Rack::Utils.escape(v)}"
        end
        options = options.join "&"
        options = "?#{options}"
      end

      "/#{dashboard.name}#{options}"
    end

    def sidebar
      html = Builder::XmlMarkup.new

      html.ul :class => "nav nav-list" do
        html.li "Dashboards", :class => "nav-header"
        Dashboard.each do |dashboard|
          html.li do
            html.a dashboard.title, :href => dashboard_path(dashboard)
          end
        end
      end
    end
  end
end