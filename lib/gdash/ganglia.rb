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
      "Last 2 Hours" => "2h",
      "Last 4 Hours" => "4h",
      "Last 12 Hours" => "12h",
      "Last 1 Day" => "day",
      "Last 2 Days" => "2days",
      "Last 1 Week" => "week",
      "Last 2 Weeks" => "2weeks",
      "Last Month" => "month",
      "Last Year" => "year"
    }

    SIZES = ["small", "medium", "large", "xlarge", "xxlarge"]

    attr_accessor :window, :size, :title, :vertical_label, :upper_limit, :lower_limit, :hosts, :metrics, :type, :legend, :aggregate, :embed

    def initialize *args, &block
      @window = "hour"
      @size = "large"
      @aggregate = true
      @embed = true
      super
    end

    def window= w
      fail "#{w.inspect} is not a valid Ganglia window" unless WINDOWS.values.include? w
      @window = w
    end

    def size= s
      fails "#{s.inspect} is not a valid Ganglia size" unless SIZES.include? s
      @size = s
    end

    def limits= range
      self.lower_limit = range.begin
      self.upper_limit = range.end
    end

    def to_url
      params = url_params.map { |k, v| "#{k}=#{Rack::Utils.escape(v)}" }.join("&")
      "http://bld-mon-03/ganglia/graph.php?#{params}"
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
       :vl        => vertical_label,
       :x         => upper_limit,
       :n         => lower_limit,
       "hreg[]"   => hosts,
       "mreg[]"   => metrics,
       :gtype     => type,
       :glegend   => legend,
       :aggregate => aggregate ? 1 : 0,
       :embed     => embed ? 1 : 0 }
    end
  end
end