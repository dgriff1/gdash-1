module GDash
  class Configuration
    attr_accessor :dashboards
    attr_accessor :documentation
    attr_accessor :org

    def initialize options = {}
      @org = ''
	  # try to find Dashboard docs
	  if Dir.exists? File.expand_path("./doc") then
		@documentation = File.expand_path("./doc")
	  else 
	  	# use default doc from gdash
		@documentation = File.expand_path(File.join(File.dirname(__FILE__), "../../doc" ))
	  end
      
	  options.each do |k, v|
        send "#{k}=", v if respond_to? :"#{k}="
      end
      
	  yield self if block_given?

    end
  end
end
