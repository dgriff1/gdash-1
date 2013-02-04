module GDash
  module Helper
    def dashboards_path options = {}
      params = nil

      if options.has_key? :data_center
        params ||= {}
        params[:data_center] = options[:data_center].nil? ? "" : options[:data_center].name
      end

      params = "?" + params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&") if params.present?

      "/#{params}"
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

      if options.has_key? :tags
        params ||= {}
        params[:tags] = options[:tags].map(&:to_s).join(" ")
      end

      if options.has_key? :data_center
        params ||= {}
        params[:data_center] = options[:data_center].nil? ? "" : options[:data_center].name
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

    def dashboard_nav dashboards = nil, current = nil, html = nil, data_center = nil
      html ||= Builder::XmlMarkup.new

      title = current.nil? ? "Dashboards" : current.title
      title ||= "Dashboards"

      html.a :class => "dropdown-toggle", :href => "#", "data-toggle" => "dropdown" do
        html.text! title
        html.b :class => "caret" do
        end
      end

      dashboards = (dashboards || Dashboard.toplevel).map { |dashboard| dashboard.filter_by_data_center data_center }.reject &:nil?

      build_dashboard_nav(dashboards, html)
    end

    def build_dashboard_nav dashboards, html
      html.ul :class => "dropdown-menu", :role => "menu", "aria-labelledby" => "dropdownMenu" do
        dashboards.each do |dashboard|
          if dashboard.nested_dashboards?
            html.li :class => "dropdown-submenu" do
              html.a dashboard.title, :href => dashboard_path(dashboard)
              build_dashboard_nav dashboard.nested_dashboards, html
            end
          else
            html.li do
              html.a dashboard.title, :href => dashboard_path(dashboard)
            end
          end
        end
      end
    end

    def data_center_nav dashboard = nil, data_center = nil
      html = Builder::XmlMarkup.new

      title = data_center.nil? ? "Data Centers" : data_center.title

      html.a :class => "dropdown-toggle", :href => "#", "data-toggle" => "dropdown" do
        html.text! title
        html.b :class => "caret" do
        end
      end

      html.ul :class => "dropdown-menu", :role => "menu", "arial-labelledby" => "dropdownMenu" do
        html.li do
          path = dashboard.nil? ? dashboards_path(:data_center => nil) : dashboard_path(dashboard, :data_center => nil)
          html.a "All", :href => path
        end

        DataCenter.all.each do |data_center|
          html.li do
            path = dashboard.nil? ? dashboards_path(:data_center => data_center) : dashboard_path(dashboard, :data_center => data_center)
            html.a data_center.title, :href => path
          end
        end
      end
    end

    private :build_dashboard_nav

    def filter_form tags = []
      html ||= Builder::XmlMarkup.new

      html.form :class => "navbar-search" do
        options = { :class => "search-query", :name => "tags", :type => "text" }
        if tags.present?
          options[:value] = tags.map(&:to_s).join(" ")
        else
          options[:placeholder] = "Filter"
        end
        html.input options
      end
    end

    def window_nav dashboard = nil
      html = Builder::XmlMarkup.new

      windows = dashboard.nil? ? Window.all : dashboard.windows
      title = dashboard.nil? ? "Time Window" : dashboard.window.title

      html.a :class => "dropdown-toggle", :href => "#", "data-toggle" => "dropdown" do
        html.text! title
        html.b :class => "caret" do
        end
      end

      html.ul :class => "dropdown-menu", :role => "menu", "aria-labelledby" => "dropdownMenu" do
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

                html.input :type => "hidden", :name => "window", :value => "custom"

                html.label "Start", :for => "start"
                html.input :type => "text", :name => "start", :placeholder => "yyyy-mm-dd HH:MM:SS"

                html.label "End", :for => "end"
                html.input :type => "text", :name => "end", :placeholder => "yyyy-mm-dd HH:MM:SS"

                html.input :type => "submit", :class => "btn btn-primary", :name => "go", :value => "Go!"
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