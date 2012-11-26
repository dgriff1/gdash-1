module GDash
  class Named < Widget
    class << self
      def inherited klass
        Widget.send :define_method, klass.to_s.demodulize.underscore do |*args, &block|
          add_child klass.define *args, &block
        end
      end

      def define name, options = {}, &block
        name = name.to_s

        if widget = Widget[name]
          options.each do |k, v|
            widget.send :"#{k}=", v if widget.respond_to? :"#{k}="
          end
          yield widget if block_given?
        else
          Widget[name] = new(options.merge(:name => name), &block)
        end

        Widget[name]
      end
    end
  end
end