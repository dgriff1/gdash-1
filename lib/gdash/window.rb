module GDash
  class Window
    class << self
      attr_accessor :default

      def register window
        windows[window.name.to_s] = window
        self.default = window if default.nil? or window.default?
      end

      def all
        windows.values.sort
      end

      def [] name
        windows[name.to_s]
      end

      def each
        all.each do |window|
          yield window if block_given?
        end
      end

      def define *args, &block
        w = new *args, &block
        register w
        w
      end

      private

      def windows
        @windows ||= {}
      end
    end

    attr_accessor :name, :length, :title, :default, :ganglia_params, :graphite_params, :cacti_params

    def initialize name, options = {}
      @name = name.to_s
      options.each do |k, v|
        send :"#{k}=", v if respond_to? :"#{k}="
      end
      yield self if block_given?
    end

    def length
      @length ||= 0
    end

    def <=> other
      length <=> (other && other.length)
    end

    def default?
      @default
    end

    def default= d
      @default = d
      self.class.default = self if @default
    end

    def ganglia_params
      time = Time.now
      @ganglia_params || {
        :r => (title || ""),
        :cs => (time - length).strftime("%m/%d/%Y %H:%M"),
        :ce => time.strftime("%m/%d/%Y %H:%M")
      }
    end

    def graphite_params
      @graphite_params || {}
    end

    def cacti_params
      time = Time.now
      @cacti_params || {
        :graph_start => (time.to_i - length),
        :graph_end => time.to_i
      }
    end
  end
end