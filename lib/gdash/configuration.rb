module GDash
  class Configuration
    attr_accessor :dashboards
    attr_accessor :location
    attr_accessor :documentation
    attr_accessor :org

    def initialize options = {}
      @location = 'prod'
      @org = ''
      options.each do |k, v|
        send "#{k}=", v if respond_to? :"#{k}="
      end

	  begin
		@documentation = File.expand_path(File.join("./doc"))
	  else
		@documentation = File.expand_path(File.join(File.dirname(__FILE__), %w{.. .. doc} ))
	  end
	  puts "Doc #{@documentation} "
      yield self if block_given?
    end
  end
end
