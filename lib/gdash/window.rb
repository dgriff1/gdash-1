module GDash
  class Window < Named
    class << self
      attr_accessor :default

      def define *args, &block
        window = super *args, &block
        self.default = window if window.default?
        window
      end
    end

    attr :end, :length, :ganglia_params, :graphite_params, :cacti_params
    attr :default, :default => false
    attr :length, :default => 0
    attr :start do
      DateTime.now
    end

    attr :ganglia_params do
      time = start
      { :r => (title || ""), :cs => (time - length).strftime("%m/%d/%Y %H:%M"), :ce => time.strftime("%m/%d/%Y %H:%M") }
    end

    attr :cacti_params do
      time = start
      { :graph_start => (time.to_i) - length, :graph_end => time.to_i }
    end

    attr :graphite_params, :default => {}

    def <=> other
      length <=> (other && other.length)
    end

    def default?
      self.default
    end
  end
end