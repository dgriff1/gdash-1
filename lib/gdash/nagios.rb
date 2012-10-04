module GDash
  class Nagios < Widget
    attr_accessor :host_group, :description
    
    def initialize host_group, *args, &block
      self.host_group = host_group.to_s
      super *args, &block
    end
    
    def to_html html = nil
      html ||= Builder::XmlMarkup.new
      
      
    end
    
    def name
      json.hostgroup_name
    end

    def description
      @description || json.hostgroup_alias
    end
    
    def hosts
      @hosts ||= HashStruct.new json.hostgroup_host_totals
    end

    def services
      @services ||= HashStruct.new json.hostgroup_service_totals
    end

    private

    class HashStruct
      def initialize hash
        @hash = hash
      end

      def method_missing name, *args, &block
        @hash[name.to_s]
      end
    end

    def json
      unless @json
        @json = open("#{nagios_host}/cgi-bin/status-json.cgi?hostgroup=#{host_group}&style=summary&noheader", :http_basic_authentication => [nagios_username, nagios_password])
        @json = JSON.parse @json
        @json = @json["hostgroups"].select do |hostgroup|
          hostgroup["hostgroup_name"] == host_group
        end
        @json = HashStruct.new @json.first
      end

      @json
    end
  end
end