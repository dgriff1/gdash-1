{ :rust => {
    :title => "Rust",
    :host => "bld-rust-01.f4tech.com",
    :topics => ["prod-server-end", "prod-beacon", "trial-server-end", "trial-beacon"]
}, :trust => {
    :title => "Trust",
    :host => "bld-rust-02.f4tech.com",
    :topics => ["dev-server-end", "test-server-end", "test-beacon"]
} }.each do |name, instance|
  GDash::Dashboard.define name do |dashboard|
    dashboard.title = instance[:title]
    dashboard.ganglia_host = "http://bld-mon-03/ganglia"

    dashboard.section :title => "System", :width => 2 do |section|
      section.ganglia_report :title => "CPU Usage" do |ganglia_report|
        ganglia_report.report = "cpu_report"
        ganglia_report.cluster = "RUST"
        ganglia_report.host = instance[:host]
        ganglia_report.size = "xlarge"
      end

      section.ganglia_report :title => "Network Usage" do |ganglia_report|
        ganglia_report.report = "network_report"
        ganglia_report.cluster = "RUST"
        ganglia_report.host = instance[:host]
        ganglia_report.size = "xlarge"
      end
    end

    dashboard.section :title => "Kafka Ingestors", :width => 2 do |section|
      instance[:topics].each do |topic|
        section.ganglia_graph :title => topic do |ganglia_graph|
          ganglia_graph.hosts = instance[:host]
          ganglia_graph.metrics = "kafka_ingestor_bld-kafka-\\d+.f4tech.com_#{topic}_\\d+_lag_bytes_gauge"
          ganglia_graph.vertical_label = "Bytes"
          ganglia_graph.type = :stack
          ganglia_graph.legend = false
        end
      end
    end
  end
end