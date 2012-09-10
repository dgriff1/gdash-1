module GDash
  class Widget
    class << self
      def inherited widget
        define_method widget.name.demodulize.underscore do |*args, &block|
          add_child widget.new(*args, &block)
        end
      end
    end

    attr_accessor :parent

    def initialize options = {}
      options.each do |k, v|
        send :"#{k}=", v if respond_to? :"#{k}="
      end

      yield self if block_given?
    end

    def children
      @children ||= []
    end

    def window
      @window || (parent && parent.window) || "hour"
    end

    def window= w
      fail "#{w.inspect} is not a valid Ganglia window" unless Ganglia::WINDOWS.values.include? w
      @window = w
    end

    private

    def add_child obj
      children << obj
      obj.parent = self
      obj
    end

    def child_groups n
      groups = []
      i = 0
      children.each do |child|
        if i == 0
          groups << []
        end

        groups.last << child
        i = (i + 1) % width
      end
      groups
    end
  end
end