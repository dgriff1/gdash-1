{ 
  :qd => {
    :title => "Denver",
    :prefix => "qd",
    :cacti_bandwidth_fw01 => {
      :graph_id => 542,
      :rra_id => 0
    },
    :cacti_bandwidth_fw02 => {
      :graph_id => 575,
      :rra_id => 0
    }
  }, 
  :qs => {
    :title => "Seattle",
    :prefix => "qs",
    :cacti_bandwidth_fw01 => {
      :graph_id => 542,
      :rra_id => 0
    },
    :cacti_bandwidth_fw02 => {
      :graph_id => 575,
      :rra_id => 0
    }
  } 

}.each do |name, site|
  GDash::Dashboard.define :"#{name}" do |dashboard|
    dashboard.title = site[:title]
    dashboard.description = "#{site[:title]} Hosts & Services"
    dashboard.ganglia_host = "http://bld-mon-03.f4tech.com/ganglia-#{site[:prefix]}"
    dashboard.cacti_host = "https://bld-mon-03.f4tech.com/cacti-#{site[:prefix]}"

    dashboard.section :title => "Key Metrics", :width => 2 do |key_metrics|
      key_metrics.cacti_graph :title => "#{site[:title]} Throughput fw01" do |cacti_graph|
        cacti_graph.graph_id = site[:cacti_bandwidth_fw01][:graph_id]
        cacti_graph.rra_id = site[:cacti_bandwidth_fw01][:rra_id]
      end

      key_metrics.cacti_graph :title => "#{site[:title]} Throughput fw02" do |cacti_graph|
        cacti_graph.graph_id = site[:cacti_bandwidth_fw02][:graph_id]
        cacti_graph.rra_id = site[:cacti_bandwidth_fw02][:rra_id]
      end

      key_metrics.ganglia_report :title => "ALM Request Rate" do |ganglia_report|
        ganglia_report.report = "slm_request_rate_report"
        ganglia_report.cluster = "ALM"
        ganglia_report.size = "xlarge"
      end

      key_metrics.ganglia_report :title => "ALM Response Time" do |ganglia_report|
        ganglia_report.report = "slm_response_time_report"
        ganglia_report.cluster = "ALM"
        ganglia_report.size = "xlarge"
      end

      key_metrics.ganglia_graph :title => "Analytics Request Rate" do |graph|
        graph.metrics = "analytics.org.mortbay.jetty.handler.StatisticsHandler.statisticshandler.0.requests$"
        graph.type = :stack
        graph.size = "xlarge"
      end

      key_metrics.ganglia_report :title => "Analytics Response Time" do |ganglia_report|
        ganglia_report.report = "analytics_response_time_report"
        ganglia_report.cluster = "ALM"
        ganglia_report.size = "xlarge"
      end
    end

    dashboard.dashboard :"#{site[:prefix]}_alm" do |alm_dash|
      alm_dash.title = "ALM App Servers"
        [
          "#{site[:prefix]}-app-01.rally.prod", 
          "#{site[:prefix]}-app-02.rally.prod", 
          "#{site[:prefix]}-app-03.rally.prod", 
          "#{site[:prefix]}-app-04.rally.prod", 
          "#{site[:prefix]}-app-05.rally.prod"
        ].each do |host|
        alm_dash.section :title => "#{host} - ALM", :width => 2 do |alm_top|
          alm_top.ganglia_report :title => "Request Rate" do |ganglia_report|
            ganglia_report.report = "slm_request_rate_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Response Time" do |ganglia_report|
            ganglia_report.report = "slm_response_time_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "ALM Sessions" do |ganglia_report|
            ganglia_report.report = "slm_sessions_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Jetty Threads" do |ganglia_report|
            ganglia_report.report = "slm_jetty_threads_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Full GC" do |ganglia_report|
            ganglia_report.report = "slm_full_gc_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "NewGen GC" do |ganglia_report|
            ganglia_report.report = "slm_new_gen_gc_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Cache Hit/Miss" do |ganglia_report|
            ganglia_report.report = "slm_cache_hit_miss_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Message Queue Sizes" do |ganglia_report|
            ganglia_report.report = "slm_message_queue_sizes_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Message Process Rates" do |ganglia_report|
            ganglia_report.report = "slm_message_process_rates_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Notification Processing Performance" do |ganglia_report|
            ganglia_report.report = "slm_notifications_processed_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Atifact Change %" do |ganglia_report|
            ganglia_report.report = "slm_artifacts_changed_per_request_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Atifact Indexing Performance" do |ganglia_report|
            ganglia_report.report = "slm_artifact_indexing_performance_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm_top.ganglia_report :title => "Quartz Connections" do |ganglia_report|
            ganglia_report.report = "slm_quartz_connections_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

        end

        alm_dash.section :title => "#{host} System Stats", :width => 4 do |system|

          system.ganglia_report :title => "Network Usage" do |ganglia_report|
            ganglia_report.report = "network_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end

          system.ganglia_report :title => "Load" do |ganglia_report|
            ganglia_report.report = "load_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end

          system.ganglia_report :title => "CPU" do |ganglia_report|
            ganglia_report.report = "cpu_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end

          system.ganglia_report :title => "Memory" do |ganglia_report|
            ganglia_report.report = "mem_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end
        end # End of system stats

      end
    end
  end
end
