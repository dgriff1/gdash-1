module GDash
  class Configuration
    attr_accessor :dashboards
    attr_accessor :location

    def initialize options = {}
      @location = 'prod'
      options.each do |k, v|
        send "#{k}=", v if respond_to? :"#{k}="
      end
      yield self if block_given?
    end
  end
end
