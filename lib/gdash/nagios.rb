module GDash
  class Nagios < Widget
    attr :host_group do
      name
    end
    attr :data_center
    
    def to_html html = nil
      html ||= Builder::XmlMarkup.new

      nagios = html.table :class => "table" do
        html.thead do
          html.th "Hosts"
          html.th "Services"
        end

        html.tbody do
          html.tr do
            html.td do
              html.span hosts.hosts_up, :class => "badge badge-success"
              html.text! "Up"
            end

            html.td do
              html.span services.services_ok, :class => "badge badge-success"
              html.text! "OK"
            end
          end

          html.tr do
            html.td do
              html.span hosts.hosts_down, :class => "badge badge-important"
              html.text! "Down"
            end

            html.td do
              html.span services.services_critical, :class => "badge badge-important"
              html.text! "Critical"
            end
          end

          html.tr do
            html.td do
              html.span hosts.hosts_unreachable, :class => "badge badge-warning"
              html.text! "Unreachable"
            end

            html.td do
              html.span services.services_unknown, :class => "badge badge-warning"
              html.text! "Unknown"
            end
          end

          html.tr do
            html.td do
              html.span hosts.hosts_pending, :class => "badge badge-info"
              html.text! "Pending"
            end

            html.td do
              html.span services.services_pending, :class => "badge badge-info"
              html.text! "Pending"
            end
          end
        end
      end

      nagios
    end
    
    # def name
    #   json.hostgroup_name
    # end

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
        @hash = hash || {}
      end

      def method_missing name, *args, &block
        @hash[name.to_s]
      end
    end

    def json
      unless @json
        @json = {"hostgroups" => [{
   "hostgroup_name"=>"some_host_group",
   "hostgroup_alias"=>"Description of the Host Group",
   "hostgroup_host_totals"=> {
     "hosts_up"=>2,
     "hosts_down"=>0,
     "hosts_unreachable"=>0,
     "hosts_pending"=>0,
     "hosts_unreachable_scheduled"=>0,
     "hosts_unreachable_acknowledged"=>0,
     "hosts_unreachable_disabled"=>0,
     "hosts_unreachable_unacknowledged"=>0,
     "hosts_down_scheduled"=>0,
     "hosts_down_acknowledged"=>0,
     "hosts_down_disabled"=>0,
     "hosts_down_unacknowledged"=>0
   },
   "hostgroup_service_totals"=> {
     "services_ok"=>20,
     "services_warning"=>0,
     "services_unknown"=>0,
     "services_critical"=>1,
     "services_pending"=>0,
     "services_warning_host_problem"=>0,
     "services_warning_scheduled"=>0,
     "services_warning_acknowledged"=>0,
     "services_warning_disabled"=>0,
     "services_warning_unacknowledged"=>0,
     "services_unknown_host_problem"=>0,
     "services_unknown_scheduled"=>0,
     "services_unknown_acknowledged"=>0,
     "services_unknown_disabled"=>0,
     "services_unknown_unacknowledged"=>0,
     "services_critical_host_problem"=>0,
     "services_critical_scheduled"=>0,
     "services_critical_acknowledged"=>0,
     "services_critical_disabled"=>0,
     "services_critical_unacknowledged"=>1
   }
  },
  {}]
}

        # @json = open("#{data_center.nagios_host}/cgi-bin/status-json.cgi?hostgroup=#{host_group}&style=summary&noheader", :http_basic_authentication => [data_center.nagios_username, data_center.nagios_password]).string
        # @json = JSON.parse @json
        @json = @json["hostgroups"].select do |hostgroup|
          hostgroup["hostgroup_name"] == name
        end
        @json = HashStruct.new @json.first
      end

      @json
    end
  end
end