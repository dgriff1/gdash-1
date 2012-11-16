module GDash
  module Data
    class Set
      def initialize data = nil
        (data || ::Set.new).each do |datum|
          self << datum
        end
      end

      def all
        @all ||= ::Set.new
      end

      def << datum
        all << datum
        datum.tags.each do |tag|
          tag(tag.to_s) << datum
        end
        timestamp(datum.timestamp) << datum
        self
      end

      def tagged *tags
        tags = tags.reduce ::Set.new do |set, tag|
          if tag.is_a? Regexp
            ts = tags().keys.select do |t|
              t =~ tag
            end
            set.union ts
          else
            set << tag.to_s
          end
        end

        tags.reduce Set.new do |set, tag|
          set.tap do |s|
            tag(tag.to_s).each do |datum|
              s << datum
            end
          end
        end
      end

      def before timestamp
        timestamps.keys.select { |t| t < timestamp }.reduce Set.new do |set, timestamp|
          set.tap do |s|
            timestamp(timestamp).each do |datum|
              s << datum
            end
          end
        end
      end

      def after timestamp
        timestamps.keys.select { |t| t > timestamp }.reduce Set.new do |set, timestamp|
          set.tap do |s|
            timestamp(timestamp).each do |datum|
              s << datum
            end
          end
        end
      end

      def window start, length
        after(start).before(start + length.to_i)
      end

      def last length
        start = Time.now - length
        window start, length
      end

      private

      def timestamps
        @timestamps ||= {}
      end

      def timestamp timestamp
        timestamps[timestamp] ||= ::Set.new
      end

      def tags
        @tags ||= {}
      end

      def tag tag
        tags[tag] ||= ::Set.new
      end
    end
  end
end