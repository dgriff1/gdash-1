module GDash
  module Helper
    def dashboards_path
      "/"
    end

    def dashboard_path dashboard, options = {}
      params = nil

      if options.has_key? :window
        params = { :window => options[:window].name }

        if options[:window].name == "custom"
          params[:end] = options[:window].start.strftime("%Y-%m-%d %H:%M:%S")
          params[:start] = (options[:window].start - options[:window].length.seconds).strftime("%Y-%m-%d %H:%M:%S")
        end
      end

      params = "?" + params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&") if params.present?

      "/dashboards/#{dashboard.name}#{params}"
    end

    def docs_path
      "/doc"
    end

    def doc_path doc
      "/doc/#{Rack::Utils.escape(doc.name)}"
    end

    def dashboard_nav current = nil, dashboards = nil, html = nil
      html ||= Builder::XmlMarkup.new

      html.ul :class => "dropdown-menu", :role => "menu", "aria-labelledby" => "dropdownMenu" do
        dashboards ||= Dashboard.toplevel.sort
        dashboards.each do |dashboard|
          if dashboard.nested_dashboards?
            html.li :class => "dropdown-submenu" do
              html.a dashboard.title, :href => dashboard_path(dashboard, :window => ((current && current.window) || Window.default))
              dashboard_nav current, dashboard.nested_dashboards, html
            end
          else
            html.li do
              html.a dashboard.title, :href => dashboard_path(dashboard, :window => ((current && current.window) || Window.default))
            end
          end
        end
      end
    end

    def window_nav dashboard = nil
      html = Builder::XmlMarkup.new

      windows = dashboard.nil? ? Window.all : dashboard.windows

      html.ul  :class => "dropdown-menu", :role => "menu", "aria-labelledby" => "dropdownMenu" do
        windows.each do |window|
          path = dashboard.nil? ? dashboards_path : dashboard_path(dashboard, :window => window)
          html.li do
            html.a window.title, :href => path
          end
        end

        path = dashboard.nil? ? dashboards_path : dashboard_path(dashboard)
        html.li :class => "dropdown-submenu" do
          html.a :href => "#", :class => "dropdown-toggle", "data-toggle" => "dropdown" do
            html.text! "Custom"
          end
          html.div :class => "dropdown dropdown-menu", :style => "padding: 20px;" do
            html.form :action => path, :method => :get do
              html.fieldset do
                html.legend "Custom Time Window"

                html.input :type => "hidden", :id => "window", :value => "custom"

                html.label "Start", :for => "start"
                html.input :type => "text", :id => "start", :placeholder => "yyyy-mm-dd HH:MM:SS"

                html.label "End", :for => "end"
                html.input :type => "text", :id => "end", :placeholder => "yyyy-mm-dd HH:MM:SS"

                html.input :type => "submit", :class => "btn btn-primary", :id => "go", :value => "Go!"
              end
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