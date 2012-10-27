ZUUL_SITES.each do |name, site|
  GDash::Dashboard.toplevel name do |zuul_site|
    zuul_site.dashboard :"#{name}_zuul_top" do |dashboard|
      dashboard.dashboard :"#{site[:prefix]}_zuul" do |zuul_dash|
        zuul_dash.title = "App Server Detail"
        site[:hosts].each do |host|

          zuul_dash.system_section "Zuul", :zuul, :title => "#{host} System Stats"

          zuul_dash.section :title => "#{host} Cassandra Stats", :width => 3 do |system|
            system.ganglia_graph :"#{host}_cassandra_load_average", :title => "Operating System System Load Average -for Cassandra" do |graph|
              graph.hosts = host
              graph.metrics = "com.sun.management.UnixOperatingSystem.OperatingSystem.SystemLoadAverage"
              graph.type = :line
              graph.size = "large"
              graph.legend = TRUE
            end

            system.ganglia_graph :"#{host}_cassandra_recent_read_latency", :title => "Recent Read Latency Micros" do |graph|
              graph.hosts = host
              graph.metrics = "org.apache.cassandra.service.StorageProxy.StorageProxy.RecentReadLatencyMicros"
              graph.type = :line
              graph.size = "large"
              graph.legend = TRUE
            end

            system.ganglia_graph :"#{host}_cassandra_recent_write_latency", :title => "Recent Write Latency Micros" do |graph|
              graph.hosts = host
              graph.metrics = "org.apache.cassandra.service.StorageProxy.StorageProxy.RecentWriteLatencyMicros"
              graph.type = :line
              graph.size = "large"
              graph.legend = TRUE
            end
          end

          zuul_dash.section :title => host, :width => 2 do |zuul|
            zuul.ganglia_report :"#{host}_request_rate", :title => "Request Rate" do |ganglia_report|
              ganglia_report.report = "zuul_request_rate_report"
              ganglia_report.cluster = "Zuul"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end

            zuul.ganglia_report :"#{host}_response_time", :title => "Request Time" do |ganglia_report|
              ganglia_report.report = "zuul_request_time_report"
              ganglia_report.cluster = "Zuul"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end
          end
        end
      end
    end
  end
end
