{ :rust => {
    :title => "Rust",
    :host => "bld-rust-01.f4tech.com",
    :topics => ["prod-server-start", "prod-server-end", "trial-server-start", "trial-server-end", "prod-beacon", "trial-beacon"]
}, :trust => {
    :title => "Trust",
    :host => "bld-rust-02.f4tech.com",
    :topics => ["test-server-start", "test-server-end", "dev-server-start", "dev-server-end", "test-beacon"]
} }.each do |name, instance|
  GDash::Dashboard.define name do |dashboard|
    dashboard.title = instance[:title]
    dashboard.description = "Rally Usage and Statistics Toolkit"
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

      section.ganglia_graph :title => "Dimension Times" do |ganglia_graph|
        ganglia_graph.hosts = instance[:host]
        ganglia_graph.metrics = ".*dimension_total_time.duration.mean"
        ganglia_graph.type = :stack
        ganglia_graph.vertical_label = "Time in ms"
        ganglia_graph.size = "xlarge"
      end

      section.ganglia_graph :title => "RabbitMQ Queues" do |ganglia_graph|
        ganglia_graph.hosts = instance[:host]
        ganglia_graph.metrics = "rust.*messages$"
        ganglia_graph.type = :stack
        ganglia_graph.vertical_label = "Queued Messages"
        ganglia_graph.size = "xlarge"
      end
    end

    dashboard.dashboard :"#{name}_kafka_ingestors" do |kafka_ingestors|
      kafka_ingestors.title = "Kafka Ingestors"

      kafka_ingestors.section :title => "Lags", :width => 2 do |section|
        instance[:topics].each do |topic|
          section.ganglia_graph :title => topic do |ganglia_graph|
            ganglia_graph.hosts = instance[:host]
            ganglia_graph.metrics = "kafka_ingestor_bld-kafka-\\d+.f4tech.com_#{topic}_\\d+_lag_bytes"
            ganglia_graph.vertical_label = "Bytes"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
            ganglia_graph.legend = false
          end
        end
      end
    end

    dashboard.dashboard :"#{name}_dimensions" do |dimensions|
      dimensions.title = "Dimension Breakdown"

      dimensions.section :title => "Dimensions", :width => 3 do |section|
        [:build_version_run, :component,    :date,
         :event,             :gesture,      :host,
         :integration,       :page,         :project,
         :proxy_remote_host, :remote_host,  :session,
         :subscriber,        :subscription, :time,
         :tps_view,          :trace,        :unhandled_exception,
         :user_agent,        :wsapi].each do |dimension|
          section.ganglia_graph :title => "#{dimension.to_s.titleize} Dimension" do |ganglia_graph|
            ganglia_graph.hosts = instance[:host]
            ganglia_graph.metrics = "^#{dimension}_dimension_.*_time.duration.mean"
            ganglia_graph.type = :stack
            ganglia_graph.vertical_label = "Time in ms"
            ganglia_graph.size = "xlarge"
          end
        end
      end
    end
  end
end