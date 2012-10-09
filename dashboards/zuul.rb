{ 
  :qd => {
    :title => "Denver",
    :prefix => "qd",
  }, 
  :qs => {
    :title => "Seattle",
    :prefix => "qs",
  } 
}.each do |name, site|
  GDash::Dashboard.define :"#{name}_zuul_top" do |dashboard|
    dashboard.parent = GDash::Dashboard[:"#{site}"]
    dashboard.title = "Zuul (Beta) #{site[:title]}"
    dashboard.description = "#{site[:title]} Zuul metrics"
    dashboard.ganglia_host = "http://bld-mon-03.f4tech.com/ganglia-#{site[:prefix]}"
    dashboard.cacti_host = "https://bld-mon-03.f4tech.com/cacti-#{site[:prefix]}"

    dashboard.section :title => "Key Metrics", :width => 2 do |key_metrics|

      key_metrics.ganglia_report :title => "Zuul Request Rate" do |ganglia_report|
        ganglia_report.report = "zuul_request_rate_report"
        ganglia_report.cluster = "Zuul"
        ganglia_report.size = "xlarge"
      end

      key_metrics.ganglia_report :title => "Zuul Response Time" do |ganglia_report|
        ganglia_report.report = "zuul_request_time_report"
        ganglia_report.cluster = "Zuul"
        ganglia_report.size = "xlarge"
      end

      key_metrics.ganglia_graph :title => "Zuul Exception Rate" do |graph|    # Request Rate 99%
        graph.hosts = "#{site[:prefix]}-zuul-*"
        graph.metrics = "zuul.service.unexpected.1MinuteRate"
        graph.type = :stack
        graph.size = "xlarge"
        graph.legend = true
      end
    end

    dashboard.dashboard :"#{site[:prefix]}_zuul_compare" do |zuul_compare|
      zuul_compare.title = "Zuul Host Comparison"
      
      zuul_compare.section :title => "Key Metric Comparison", :width => 5 do |compare| 
        [
          "#{site[:prefix]}-zuul-01.rally.prod", 
          "#{site[:prefix]}-zuul-02.rally.prod", 
          "#{site[:prefix]}-zuul-03.rally.prod" 
        ].each do |host|

          compare.ganglia_report :title => "Load" do |ganglia_report|
            ganglia_report.report = "load_report"
            ganglia_report.cluster = "Zuul"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end

          compare.ganglia_report :title => "Request Rate" do |ganglia_report|
            ganglia_report.report = "zuul_request_rate_report"
            ganglia_report.cluster = "Zuul"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

    #      compare.ganglia_report :title => "Response Time" do |ganglia_report|
    #        ganglia_report.report = "zuul_request_time_report"
    #        ganglia_report.cluster = "Zuul"
    #        ganglia_report.host = host
    #        ganglia_report.size = "large"
    #      end

          compare.ganglia_graph :title => "Request Rate Total 99 Percentile" do |graph|    # Request Rate 99%
            graph.hosts = host
            graph.metrics = "zuul.requests.total.99percentile"
            graph.type = :line
            graph.size = "large"
            graph.vertical_label = "Milliseconds"
            graph.upper_limit = 30
            graph.lower_limit = 0
            graph.legend = TRUE
          end

          compare.ganglia_graph :title => "JVM Memory Heap Usage" do |graph|                    #JVM Memory Heap Memory Usage
            graph.hosts = host
            graph.metrics = "jvm.memory.heap_usage"         
            graph.type = :line
            graph.size = "large"
            # graph.vertical_label = "Milliseconds"
            # graph.upper_limit = 30
            # graph.lower_limit = 0
            graph.legend = TRUE
          end

          compare.ganglia_graph :title => "CPU Idle Percentile" do |graph|
            graph.hosts = host
            graph.metrics = "cpu_idle"
            graph.type = :line
            graph.size = "large"
            # graph.vertical_label = "Milliseconds"
            # graph.upper_limit = 30
            # graph.lower_limit = 0
            graph.legend = TRUE
           end

        end # End of host block
      end # End of compare section
    end # End of compare dashboard

    dashboard.dashboard :"#{site[:prefix]}_zuul" do |zuul_dash|
      zuul_dash.title = "Zuul App Server Detail"
        [
          "#{site[:prefix]}-zuul-01.rally.prod", 
          "#{site[:prefix]}-zuul-02.rally.prod", 
          "#{site[:prefix]}-zuul-03.rally.prod" 
        ].each do |host|

        zuul_dash.section :title => "#{host} System Stats", :width => 4 do |system|

          system.ganglia_report :title => "Network Usage" do |ganglia_report|
            ganglia_report.report = "network_report"
            ganglia_report.cluster = "Zuul"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end

          system.ganglia_report :title => "Load" do |ganglia_report|
            ganglia_report.report = "load_report"
            ganglia_report.cluster = "Zuul"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end

          system.ganglia_report :title => "CPU" do |ganglia_report|
            ganglia_report.report = "cpu_report"
            ganglia_report.cluster = "Zuul"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end

          system.ganglia_report :title => "Memory" do |ganglia_report|
            ganglia_report.report = "mem_report"
            ganglia_report.cluster = "Zuul"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end
        end # End of system stats

         zuul_dash.section :title => "#{host} Cassandra Stats", :width => 3 do |system| 


          system.ganglia_graph :title => "Operating System System Load Average -for Cassandra" do |graph|    # cassandra
            graph.hosts = host
            graph.metrics = "com.sun.management.UnixOperatingSystem.OperatingSystem.SystemLoadAverage"
            graph.type = :line
            graph.size = "large"
            # graph.vertical_label = "Milliseconds"
            # graph.upper_limit = 30
            # graph.lower_limit = 0
            graph.legend = TRUE
          end

          system.ganglia_graph :title => "Recent Read Latency Micros" do |graph|                                  #cassandra
            graph.hosts = host
            graph.metrics = "org.apache.cassandra.service.StorageProxy.StorageProxy.RecentReadLatencyMicros"         
            graph.type = :line
            graph.size = "large"
            # graph.vertical_label = "Milliseconds"
            # graph.upper_limit = 30
            # graph.lower_limit = 0
            graph.legend = TRUE
          end

          system.ganglia_graph :title => "Recent Write Latency Micros" do |graph|                                  # Cassandra
            graph.hosts = host
            graph.metrics = "org.apache.cassandra.service.StorageProxy.StorageProxy.RecentWriteLatencyMicros"
            graph.type = :line
            graph.size = "large"
            # graph.vertical_label = "Milliseconds"
            # graph.upper_limit = 30
            # graph.lower_limit = 0
            graph.legend = TRUE
           end

         end # END of System Stats (Cassandra Stats)

        zuul_dash.section :title => "#{host} Zuul", :width => 2 do |zuul|
          zuul.ganglia_report :title => "Request Rate" do |ganglia_report|
            ganglia_report.report = "zuul_request_rate_report"
            ganglia_report.cluster = "Zuul"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          zuul.ganglia_report :title => "Request Time" do |ganglia_report|
            ganglia_report.report = "zuul_request_time_report"
            ganglia_report.cluster = "Zuul"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end





        end # End o "Zuul Metrics

      end # End of host each block

    end # End o "Zuul Dashboard

  end # End of site Dashboard

end # End of site each block
