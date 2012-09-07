module GDash
  class Dashboard < Widget
    class << self
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

      private

      def dashboards
        @dashboards ||= {}
      end
    end

    attr_accessor :name, :title, :description, :refresh

    def initialize name, *args, &block
      @refresh = 60
      @name = name
      super(*args, &block)
      self.class.register self
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new

      dashboard = html.h1 do
        html.text!(title || "")
        html.small description
      end

      children.each do |child|
        child.to_html html
      end

      dashboard
    end
  end
end