module GDash
  class Ganglia < Widget
    class << self
      def inherited widget
        Widget.send :define_method, widget.name.demodulize.underscore do |*args, &block|
          add_child widget.new(*args, &block)
        end
      end
    end

    SIZES = ["small", "medium", "large", "xlarge", "xxlarge"]

    attr_accessor :size, :title, :embed

    def initialize *args, &block
      @size = "large"
      @embed = true
      super
    end

    def size= s
      raise ArgumentError.new("#{s.inspect} is not a valid Ganglia size") unless SIZES.include? s
      @size = s
    end

    def to_url
      params = url_params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&")
      "#{ganglia_host}/graph.php?#{params}"
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new
      html.img :src => to_url.to_sym
    end

    private

    def url_params
      window.ganglia_params.merge({
       :z         => size,
       :title     => title,
       :embed     => embed ? 1 : 0 })
    end
  end
end