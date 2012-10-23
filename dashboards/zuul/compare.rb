ZUUL_SITES.each do |name, site|
  GDash::Dashboard.toplevel name do |zuul_site|
    zuul_site.dashboard :"#{name}_zuul_top" do |dashboard|
      dashboard.dashboard :"#{site[:prefix]}_zuul_compare" do |zuul_compare|
        zuul_compare.title = "Zuul Host Comparison"

        zuul_compare.section :title => "Key Metric Comparison", :width => 5 do |compare|
          site[:hosts].each do |host|
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

            compare.ganglia_graph :title => "Request Rate Total 99 Percentile" do |graph|
              graph.hosts = host
              graph.metrics = "zuul.requests.total.99percentile"
              graph.type = :line
              graph.size = "large"
              graph.vertical_label = "Milliseconds"
              graph.upper_limit = 30
              graph.lower_limit = 0
              graph.legend = TRUE
            end

            compare.ganglia_graph :title => "JVM Memory Heap Usage" do |graph|
              graph.hosts = host
              graph.metrics = "jvm.memory.heap_usage"
              graph.type = :line
              graph.size = "large"
              graph.legend = TRUE
            end

            compare.ganglia_graph :title => "CPU Idle Percentile" do |graph|
              graph.hosts = host
              graph.metrics = "cpu_idle"
              graph.type = :line
              graph.size = "large"
              graph.legend = TRUE
            end
          end
        end
      end
    end
  end
end
