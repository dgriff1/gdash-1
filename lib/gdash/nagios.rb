module GDash
  class Nagios < Widget
    attr_accessor :host_group, :description
    
    def initialize host_group, *args, &block
      self.host_group = host_group.to_s
      super *args, &block
    end
    
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
        @hash = hash || {}
      end

      def method_missing name, *args, &block
        @hash[name.to_s]
      end
    end

    def json
      unless @json
        @json = open("#{data_center.nagios_host}/cgi-bin/status-json.cgi?hostgroup=#{host_group}&style=summary&noheader", :http_basic_authentication => [data_center.nagios_username, data_center.nagios_password]).string
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