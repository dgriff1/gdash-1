module GDash
  class Dashboard < Named
    class << self
      def each
        dashboards.values.each do |dashboard|
          yield dashboard if block_given?
        end
      end

      def [] name
        dashboards.stringify_keys[name.to_s]
      end

      def toplevel *args, &block
        @toplevel ||= []

        if args.present?
          dashboard = define *args, &block
          @toplevel << dashboard unless @toplevel.include?(dashboard)
          dashboard
        else
          @toplevel
        end
      end

      def dashboards
        @dashboards ||= {}
      end
    end

    attr_accessor :title, :description, :refresh

    def initialize *args, &block
      @refresh = 60
      super(*args, &block)
      raise ArgumentError.new("A name is required") if name.blank?
      self.class.dashboards[name.to_s] = self
    end

    def clone
      self.class.new :name => name, :window => window, :data_center => data_center, :title => title, :description => description, :refresh => refresh, :windows => windows
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new

      dashboard = html.h1 do
        html.text!(title || "")
        html.br
        html.small description
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