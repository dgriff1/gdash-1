PROD_SITES.each do |name, site|
  GDash::Dashboard.define :"#{name}" do |dashboard|
    dashboard.dashboard :"#{site[:prefix]}_alm_compare" do |alm_compare|
      alm_compare.title = "ALM Host Comparison"

      alm_compare.section :title => "Key Metric Comparison", :width => 5 do |compare|
        site[:app_servers].each do |host|
          [["Load", "load_report"],
           ["Request Rate", "slm_request_rate_report"],
           ["Response Time", "slm_response_time_report"],
           ["ALM Connections", "slm_connections_report"],
           ["JVM Memory", "slm_all_jvm_memory_report"]].each do |(title, report)|
            compare.ganglia_report :"#{site[:prefix]}_#{host}_key_metric_#{report}", :title => title do |ganglia_report|
              ganglia_report.report = report
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end
          end
        end
      end

      site[:app_servers].each do |host|
        alm_compare.dashboard :"#{site[:prefix]}_alm_#{host}" do |alm_dash|
          alm_dash.title = host

          alm_dash.system_section "ALM", "#{site[:prefix]}_#{host}_system", :title => "#{host} System Stats"

          alm_dash.section :title => "#{host} - ALM", :width => 2 do |alm|
            [["Request Rate", "slm_request_rate_report"],
             ["Response Time", "slm_response_time_report"],
             ["JVM Memory", "slm_all_jvm_memory_report"],
             ["ALM Sessions", "slm_sessions_report"],
             ["ALM Connections", "slm_connections_report"],
             ["Jetty Threads", "slm_jetty_threads_report"],
             ["Full GC", "slm_full_gc_report"],
             ["NewGen GC", "slm_new_gen_gc_report"],
             ["Cache Hit/Miss", "slm_cache_hit_miss_report"],
             ["Message Queue Sizes", "slm_message_queue_sizes_report"],
             ["Message Process Rates", "slm_message_process_rates_report"],
             ["Notification Processing Performance", "slm_notifications_processed_report"],
             ["Artifact Change %", "slm_artifacts_changed_per_request_report"],
             ["Artifact Indexing Performance", "slm_artifact_indexing_performance_report"],
             ["Quartz Connections", "slm_quartz_connections_report"]].each do |(title, report)|
              alm.ganglia_report :"#{site[:prefix]}_#{host}_comparison_#{report}", :title => title do |ganglia_report|
                ganglia_report.report = report
                ganglia_report.cluster = "ALM"
                ganglia_report.host = host
                ganglia_report.size = "large"
              end
            end
          end

          alm_dash.section :title => "#{host} - Analytics", :width => 2 do |analytics|
            analytics.ganglia_report :"#{site[:prefix]}_#{host}_analytics_request_rate", :title => "Request Rate" do |ganglia_report|
              ganglia_report.report = "analytics_jvm_request_rate_report"
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end

            analytics.ganglia_report :"#{site[:prefix]}_#{host}_analytics_response_time", :title => "Response Time" do |ganglia_report|
              ganglia_report.report = "slm_response_time_report"
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.custom :prefix => "analytics"
              ganglia_report.size = "large"
            end

            analytics.ganglia_report :"#{site[:prefix]}_#{host}_analytics_alm_sessions", :title => "ALM Sessions" do |ganglia_report|
              ganglia_report.report = "slm_sessions_report"
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end

            analytics.ganglia_report :"#{site[:prefix]}_#{host}_analytics_jvm_memory", :title => "JVM Memory" do |ganglia_report|
              ganglia_report.report = "slm_all_jvm_memory_report"
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.custom :prefix => "analytics"
              ganglia_report.size = "large"
            end
          end
        end
      end
    end
  end
end
