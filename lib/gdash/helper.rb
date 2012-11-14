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
          params[:start] = options[:window].start.strftime("%Y-%m-%d %H:%M:%S")
          params[:end] = (options[:window].start + options[:window].length.seconds).strftime("%Y-%m-%d %H:%M:%S")
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

      html.ul :class => "nav nav-list" do
        html.li "Dashboards", :class => "nav-header" if dashboards.nil?

        dashboards ||= Dashboard.toplevel.sort
        dashboards.each do |dashboard|
          options = {}
          options[:class] = "active" if dashboard == current
          html.li options do
            html.a dashboard.title, :href => dashboard_path(dashboard, :window => ((current && current.window) || Window.default))
          end

          if dashboard.nested_dashboards?
            html.li do
              dashboard_nav current, dashboard.nested_dashboards, html
            end
          end
        end
      end
    end

    def window_nav dashboard, current = nil
      html = Builder::XmlMarkup.new

      html.ul :class => "nav nav-pills" do
        dashboard.windows.each do |window|
          options = {}
          options[:class] = "active" if window == current
          html.li options do
            html.a window.title, :href => dashboard_path(dashboard, :window => window)
          end
        end

        html.li :class => "dropdown" do
          html.a :href => "#", :class => "dropdown-toggle", "data-toggle" => "dropdown" do
            html.text! "Custom"
            html.b "", :class => "caret"
          end
          html.div :class => "dropdown-menu", :style => "padding: 20px;" do
            html.form :action => dashboard_path(dashboard), :method => :get do
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