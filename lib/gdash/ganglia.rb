module GDash
  class Ganglia < Named
    SIZES = ["small", "medium", "large", "xlarge", "xxlarge"]

    attr_accessor :name, :size, :title, :embed

    def initialize *args, &block
      @size = "large"
      @embed = true
      super *args, &block
    end

    def size= s
      raise ArgumentError.new("#{s.inspect} is not a valid Ganglia size") unless SIZES.include? s
      @size = s
    end

    def custom args = {}
      if args.blank?
        @custom ||= {}
      else
        @custom = (@custom || {}).merge args
      end
    end

    def to_url
      params = url_params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&")
      "#{data_center.ganglia_host}/graph.php?#{params}"
    end

    def to_html html = nil
      html ||= Builder::XmlMarkup.new
      html.img :src => to_url.to_sym
    end

    private

    def url_params
      window.ganglia_params.merge(custom).merge({
       :z         => size,
       :title     => title,
       :embed     => embed ? 1 : 0 })
    end
  end
end