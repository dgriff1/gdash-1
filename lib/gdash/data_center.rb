module GDash
  class DataCenter
    class << self
      def define name, options = {}, &block
        name = name.to_s
        if data_center = data_centers[name]
          options.each do |k, v|
            data_center.send :"#{k}=", v if data_center.respond_to? :"#{k}="
          end
          yield data_center if block_given?
        else
          data_centers[name] = new(options.merge(:name => name), &block)
        end

        data_centers[name]
      end

      def [] name
        data_centers[name.to_s]
      end

      def all
        data_centers.values
      end

      private

      def data_centers
        @data_centers ||= {}
      end
    end

    attr_accessor :name, :title, :prefix, :ganglia_host, :graphite_host, :cacti_host, :nagios_host, :nagios_username, :nagios_password

    def initialize options = {}
      options.each do |k, v|
        send "#{k}=", v if respond_to? "#{k}="
      end
      yield self if block_given?
    end
  end
end