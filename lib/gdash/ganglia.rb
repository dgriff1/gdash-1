module GDash
  class Ganglia < Widget
    class << self
      def inherited widget
        Widget.send :define_method, widget.name.demodulize.underscore do |*args, &block|
          add_child widget.new(*args, &block)
        end
      end
    end

    WINDOWS = {
      "Last Hour" => "hour",
      "Last 2 Hours" => "2hr",
      "Last 4 Hours" => "4hr",
      "Last 12 Hours" => "12hr",
      "Last Day" => "day",
      "Last 2 Days" => "2days",
      "Last Week" => "week",
      "Last 2 Weeks" => "2weeks",
      "Last Month" => "month",
      "Last Year" => "year"
    }

    WINDOW_NAMES = [
      "Last Hour",
      "Last 2 Hours",
      "Last 4 Hours",
      "Last 12 Hours",
      "Last Day",
      "Last 2 Days",
      "Last Week",
      "Last 2 Weeks",
      "Last Month",
      "Last Year"
    ]

    SIZES = ["small", "medium", "large", "xlarge", "xxlarge"]

    attr_accessor :size, :title, :embed

    def initialize *args, &block
      @window = "hour"
      @size = "large"
      @embed = true
      super
    end

    def size= s
      fails "#{s.inspect} is not a valid Ganglia size" unless SIZES.include? s
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
      {:r         => window,
       :z         => size,
       :title     => title,
       :embed     => embed ? 1 : 0 }
    end
  end
end