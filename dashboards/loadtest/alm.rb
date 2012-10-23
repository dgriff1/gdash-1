GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.dashboard :loadtest do |dashboard|
    dashboard.dashboard :"loadtest_alm" do |alm_dash|
      alm_dash.title = "ALM App Server Detail"

      LOADTEST_HOSTS.each do |host|
        alm_dash.system_section "Loadtest", :loadtest, :title => "#{host} System Stats"

        alm_dash.section :title => "#{host} - ALM", :width => 4 do |alm|
          alm.ganglia_report :"#{host}_alm_request_rate", :title => "Request Rate" do |ganglia_report|
            ganglia_report.report = "slm_request_rate_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_response_time", :title => "Response Time" do |ganglia_report|
            ganglia_report.report = "slm_response_time_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_sessions", :title => "ALM Sessions" do |ganglia_report|
            ganglia_report.report = "slm_sessions_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_jetty_threads", :title => "Jetty Threads" do |ganglia_report|
            ganglia_report.report = "slm_jetty_threads_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_full_gc", :title => "Full GC" do |ganglia_report|
            ganglia_report.report = "slm_full_gc_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_new_gen_gc", :title => "NewGen GC" do |ganglia_report|
            ganglia_report.report = "slm_new_gen_gc_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_cache_hit_miss", :title => "Cache Hit/Miss" do |ganglia_report|
            ganglia_report.report = "slm_cache_hit_miss_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_message_queue_sizes", :title => "Message Queue Sizes" do |ganglia_report|
            ganglia_report.report = "slm_message_queue_sizes_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_message_process_rates", :title => "Message Process Rates" do |ganglia_report|
            ganglia_report.report = "slm_message_process_rates_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_notification_processing_performance", :title => "Notification Processing Performance" do |ganglia_report|
            ganglia_report.report = "slm_notifications_processed_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_artifact_change_pct", :title => "Artifact Change %" do |ganglia_report|
            ganglia_report.report = "slm_artifacts_changed_per_request_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_artifact_indexing_performance", :title => "Artifact Indexing Performance" do |ganglia_report|
            ganglia_report.report = "slm_artifact_indexing_performance_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          alm.ganglia_report :"#{host}_alm_quartz_connections", :title => "Quartz Connections" do |ganglia_report|
            ganglia_report.report = "slm_quartz_connections_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end
        end

        alm_dash.section :title => "#{host} - Analytics", :width => 4 do |analytics|
          analytics.ganglia_report :"#{host}_analytics_request_rate", :title => "Request Rate" do |ganglia_report|
            ganglia_report.report = "analytics_request_rate_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          analytics.ganglia_report :"#{host}_analytics_response_time", :title => "Response Time" do |ganglia_report|
            ganglia_report.report = "analytics_response_time_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          analytics.ganglia_report :"#{host}_analytics_alm_sessions", :title => "ALM Sessions" do |ganglia_report|
            ganglia_report.report = "slm_sessions_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end
        end
      end
    end
  end
end