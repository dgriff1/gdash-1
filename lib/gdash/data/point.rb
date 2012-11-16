module GDash
  module Data
    class Point
      attr_reader :datum, :timestamp, :tags

      def initialize datum, timestamp, options = {}
        @datum = datum
        @timestamp = timestamp
        options.each do |k, v|
          send :"#{k}=", v if respond_to? :"#{k}="
        end
        yield self if block_given?
      end

      def tags
        @tags ||= []
      end

      def tags= tags
        if tags.is_a? Array
          @tags = tags.map(&:to_s)
        else
          @tags = [tags.to_s]
        end
      end

      def tag tag
        tags << tag.to_s
      end

      def tagged? tag
        tags.include? tag.to_s
      end

      def to_hash
        { :datum => datum, :timestamp => timestamp }
      end
    end
  end
end