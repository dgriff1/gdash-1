module GDash
  class Named < Base
    class << self
      def define name, options = {}, &block
        instances[name] ||= new name, options

        if block_given?
          if block.arity < 1
            instances[name].instance_eval &block
          else
            yield instances[name] 
          end
        end

        instances[name]
      end

      def [] name
        instances[name]
      end

      def all
        instances.values
      end

      def each
        all.each do |instance|
          yield instance if block_given?
        end
      end

      private

      def instances
        @instances ||= {}.with_indifferent_access
      end
    end
  end
end