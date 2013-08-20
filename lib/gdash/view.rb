module GDash
  class View
    attr_accessor :model, :window, :current_page, :tab_path, :tab_route

    def initialize model, options = {}
      self.window = options[:window] || Window.default
      self.tab_path = options[:tab_path] || []
      self.tab_route = []
      self.model = model
      self.current_page = options[:page] || (model.pages.first if model.respond_to? :pages)
      @scope = Scope.new nil, {}
    end

    def with_scope options = {}, &block
      @scope = Scope.new @scope, options
      res = yield if block_given?
      @scope = @scope.instance_variable_get(:@parent)
      res
    end

    def dashboard_path dashboard, page = nil, *tabs
      options = tabs.extract_options!
      page = "/#{page.name}" if page
      tabs = tabs.map { |tab| "/#{tab}" }.join
      options = options.has_key?(:window) ? "?window=#{options[:window].name}" : ""
      "/dashboards/#{dashboard.name}#{page}#{tabs}#{options}"
    end

    def page_nav dashboard
      html.div :id => "page-nav", :class => "well fullscreen-hidden" do
        html.ul :class => "nav nav-pills nav-stacked" do
          dashboard.pages.each do |page|
            if page == current_page
              html.li :class => "active" do
                html.a page.title, :href => dashboard_path(dashboard, page)
              end
            else
              html.li do
                html.a page.title, :href => dashboard_path(dashboard, page)
              end
            end
          end
        end
      end
    end

    def window_nav
      html.ul :id => "window-nav", :class => "nav nav-pills fullscreen-hidden" do
        model.windows.each do |window|
          if (self.window.nil? && window.default) or (window.name == self.window.name)
            html.li :class => "active" do
              html.a window.title, :href => dashboard_path(model, current_page, *(tab_path + [{:window => window}]))
            end
          else
            html.li do
              html.a window.title, :href => dashboard_path(model, current_page, *(tab_path + [{:window => window}]))
            end
          end
        end

        html.li :class => "dropdown-submenu" do
          html.a :href => "#", :class => "dropdown-toggle", "data-toggle" => "dropdown" do
            html.text! "Custom"
          end
          html.div :class => "dropdown dropdown-menu", :style => "padding: 20px;" do
            html.form :action => dashboard_path(model, current_page, *tab_path), :method => :get do
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

    def dashboard dashboard, options = {}
      html.div :class => "row-fluid" do
        html.div :class => "span2 fullscreen-hidden" do
          page_nav dashboard
        end

        html.div :class => "fullscreen-expanded" do
          html.div :class => "row-fluid" do
            window_nav
          end

          html.div :class => "row-fluid" do
            render current_page
          end
        end
      end
    end

    def page page, options = {}
      html.h1 :class => "fullscreen-hidden" do
        html.text!(page.title || "")
        html.br
        html.small(page.description || "")
      end

      page.children.each do |child|
        render child
      end
    end

    def tab_set tab_set, options = {}
      active_tab_name = @active_tabs.shift
      active_tab = tab_set.tabs.select { |t| t.name == active_tab_name }.first || tab_set.tabs.first

      html.ul :class => "nav nav-tabs fullscreen-hidden" do
        tab_set.tabs.each do |tab|
          with_tab_route tab.name do
            render tab, :active => (active_tab.name == tab.name)
          end
        end
      end

      with_tab_route active_tab.name do
        active_tab.children.each do |child|
          render child
        end
      end
    end

    def tab tab, options = {}
      html_options = options[:active] ? { :class => "active" } : {}

      html.li html_options do
        html.a tab.title, :href => dashboard_path(self.model, current_page, *tab_route)
      end
    end

    def section section, options = {}
      with_scope options.merge(:data_center => section.options[:data_center], :hosts => section.options[:hosts], :host => section.options[:host], :ganglia_prefix => section.options[:ganglia_prefix], :ganglia_cluster => section.options[:ganglia_cluster]) do
        html.div :class => "row-fluid" do
          html.h3 section.title, :class => "fullscreen-hidden"
          html.table :class => "table" do
            groups_of(section.widgets, section.width).each do |group|
              html.tr do
                group.each do |widget|
                  html.td do
                    id = widget.object_id

                    # html.a :href => "#widget-#{id}", "data-toggle" => "modal" do
                      render widget
                    # end

                    # html.div :id => "widget-#{id}", :class => "modal hide", :tabindex => "1", :role => "dialog", "aria-labelledby" => "widgetModelLabel", "aria-hidden" => true do
                    #   html.div :class => "modal-header" do
                    #     html.button "x", :type => "button", :class => "close", "data-dismiss" => "modal", "aria-hidden" => true
                    #     html.h3 widget.title
                    #   end

                    #   html.div :class => "modal-body" do
                    #     html.table :class => "table" do
                    #       groups_of(Window.all, 3).each do |row|
                    #         html.tr do
                    #           row.each do |window|
                    #             html.td do
                    #               with_scope :window => window do
                    #                 render widget
                    #               end
                    #             end
                    #           end
                    #         end
                    #       end
                    #     end
                    #   end

                    #   html.div :class => "modal-footer" do
                    #     html.button "Close", :class => "btn btn-primary", "data-dismiss" => "modal", "aria-hidden" => true
                    #   end
                    # end
                  end
                end
              end
            end
          end
        end
      end
    end

    def widget widget, options = {}
      widget.to_s
    end

    def to_html
      @active_tabs = tab_path.dup
      with_scope :window => window do
        render self.model
      end
      buf
    end

    def render model, *args
      method_name = model.class.to_s.demodulize.underscore
      send method_name, model, *args if respond_to? method_name
    end
 
    def html
      @html ||= Builder::XmlMarkup.new(:target => buf)
    end

    def buf
      @buf ||= ""
    end

    def with_tab_route route
      tab_route << route
      yield if block_given?
      tab_route.pop
    end

    def groups_of values, size
      groups = []

      i = 0
      values.each do |value|
        if i == 0
          groups << []
        end

        groups.last << value
        i = (i + 1) % size
      end

      groups
    end
  end
end
