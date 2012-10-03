module GDash
  class Dashboard < Widget
    class << self
      def define *args, &block
        dashboard = new *args, &block
        toplevel << dashboard
        dashboard
      end

      def register dashboard
        dashboards[dashboard.name] = dashboard
      end

      def [] name
        dashboards[name]
      end

      def each
        dashboards.values.each do |dashboard|
          yield dashboard if block_given?
        end
      end

      def toplevel
        @toplevel ||= []
      end

      def dashboards
        @dashboards ||= {}
      end
    end

    attr_accessor :name, :title, :description, :refresh, :nagios_host_group

    def initialize name, *args, &block
      @refresh = 60
      @name = name
      super(*args, &block)
      self.class.register self
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new

      dashboard = html.div :class => "row-fluid" do
        html.div :class => ".span12" do
          html.h1 :class => ".span6" do
            html.text!(title || "")
            html.br
            html.small description
          end
      
          if nagios_host and nagios_host_group
            nagios = open("#{nagios_host}/cgi-bin/status.cgi?hostgroup=#{nagios_host_group}&style=summary&noheader", :http_basic_authentication => [nagios_user, nagios_password]).read
            html.div nagios.to_sym
          end
        end
      end

      renderable_children.each do |child|
        child.to_html html
      end

      dashboard
    end

    def windows
      @windows ||= []
      (Window.all + @windows).sort
    end

    def custom_window *args, &block
      @windows ||= []
      w = Window.new(*args, &block)
      @windows << w
      w
    end

    def <=> other
      (title || "") <=> ((other && other.title) || "")
    end
  end
end