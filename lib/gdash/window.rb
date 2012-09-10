module GDash
  class Window
    class << self
      attr_accessor :default

      def register window
        windows << window
        self.default = window unless default
      end

      def all
        windows.sort
      end

      def each
        all.each do |window|
          yield window if block_given?
        end
      end

      private

      def windows
        @windows ||= []
      end
    end

    attr_accessor :name, :length, :title, :default, :ganglia_params, :graphite_params, :cacti_params

    def initialize name, options = {}
      @name = name
      options.each do |k, v|
        send :"#{k}=", v if respond_to? :"#{k}="
      end
      yield self if block_given?
      self.class.register self
    end

    def <=> other
      (length || 0) <=> ((other && other.length) || 0)
    end

    def default?
      @default
    end

    def default= d
      @default = d
      self.class.default = self if @default
    end

    def ganglia_params
      @ganglia_params ||= {}
    end

    def graphite_params
      @graphite_params ||= {}
    end

    def cacti_params
      @cacti_params ||= {}
    end
  end
end