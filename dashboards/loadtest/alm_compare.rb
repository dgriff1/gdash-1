GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.dashboard :loadtest do |dashboard|
    dashboard.dashboard :loadtest_alm_compare do |alm_compare|
      alm_compare.title = "ALM Host Comparison"

      alm_compare.section :title => "Key Metric Comparison", :width => 5 do |compare|
        LOADTEST_HOSTS.each do |host|
          compare.ganglia_report :"#{host}_load", :title => "Load" do |ganglia_report|
            ganglia_report.report = "load_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "medium"
          end

          compare.ganglia_report :"#{host}_request_rate", :title => "Request Rate" do |ganglia_report|
            ganglia_report.report = "slm_request_rate_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          compare.ganglia_report :"#{host}_response_time", :title => "Response Time" do |ganglia_report|
            ganglia_report.report = "slm_response_time_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          compare.ganglia_report :"#{host}_connections", :title => "ALM Connections" do |ganglia_report|
            ganglia_report.report = "slm_connections_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end

          compare.ganglia_report :"#{host}_new_gen_gc", :title => "NewGen GC" do |ganglia_report|
            ganglia_report.report = "slm_new_gen_gc_report"
            ganglia_report.cluster = "Loadtest"
            ganglia_report.host = host
            ganglia_report.size = "large"
          end
        end
      end
    end
  end
end