module GDash
  class GangliaGraph < Ganglia
    attr_accessor :hosts, :metrics, :vertical_label, :upper_limit, :lower_limit, :type, :legend, :aggregate

    def initialize *args, &block
      @aggregate = true
      super
    end

    def limits= range
      self.lower_limit = range.begin
      self.upper_limit = range.end
    end

    private

    def url_params
      super.merge({
        :vl        => vertical_label,
        :x         => upper_limit,
        :n         => lower_limit,
        :gtype     => type,
        :glegend   => legend ? "show" : "hide",
        :aggregate => aggregate ? 1 : 0,
        "hreg[]"   => hosts,
        "mreg[]"   => metrics
      })
    end
  end
end