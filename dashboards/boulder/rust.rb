GDash::Dashboard.toplevel :boulder do |boulder|
  { :rust => {
      :title => "Rust",
      :host => "bld-rust-01.f4tech.com",
      :topics => ["prod-server-start", "prod-server-end", "trial-server-start", "trial-server-end", "prod-beacon", "trial-beacon"]
  }, :trust => {
      :title => "Trust",
      :host => "bld-rust-02.f4tech.com",
      :topics => ["test-server-start", "test-server-end", "loadtest-server-start", "loadtest-server-end", "dev-server-start", "dev-server-end", "test-beacon"]
  } }.each do |name, instance|
    boulder.dashboard name do |dashboard|
      dashboard.title = instance[:title]
      dashboard.description = "Rally Usage and Statistics Toolkit"

      dashboard.section :title => "Nagios", :width => 1 do |nagios|
        nagios.nagios "rust-servers"
      end

      dashboard.system_section "RUST", "#{name}_system"

      dashboard.section :title => "Rust", :width => 2 do |section|
        section.ganglia_graph :"#{name}_dimension_times", :title => "Dimension Times" do |ganglia_graph|
          ganglia_graph.hosts = instance[:host]
          ganglia_graph.metrics = ".*dimension_total_time.duration.mean"
          ganglia_graph.type = :stack
          ganglia_graph.vertical_label = "Time in ms"
          ganglia_graph.size = "xlarge"
          ganglia_graph.legend = true
        end

        section.ganglia_graph :"#{name}_rabbit_mq_queues", :title => "RabbitMQ Queues" do |ganglia_graph|
          ganglia_graph.hosts = instance[:host]
          ganglia_graph.metrics = "rust.*messages$"
          ganglia_graph.type = :stack
          ganglia_graph.vertical_label = "Queued Messages"
          ganglia_graph.size = "xlarge"
          ganglia_graph.legend = true
        end
      end

      dashboard.dashboard :"#{name}_kafka_ingestors" do |kafka_ingestors|
        kafka_ingestors.title = "Kafka Ingestors"

        kafka_ingestors.section :title => "Lag in Bytes", :width => 2 do |section|
          instance[:topics].each do |topic|
            section.ganglia_graph "#{name}_#{topic}_lag", :title => topic do |ganglia_graph|
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

        [:build_version_run, :component,       :date,
         :event,             :gesture_request, :host,
         :integration,       :page,            :project,
         :proxy_remote_host, :remote_host,     :session,
         :subscriber,        :subscription,    :time,
         :tps_view,          :trace,           :unhandled_exception,
         :user_agent,        :wsapi].each do |dimension|
          dimensions.section :title => dimension.to_s.titleize, :width => 3 do |section|
            section.ganglia_graph :"#{name}_#{dimension}_times", :title => "#{dimension.to_s.titleize} Times" do |ganglia_graph|
              ganglia_graph.hosts = instance[:host]
              ganglia_graph.metrics = "^#{dimension}_dimension_.*_time.duration.mean"
              ganglia_graph.type = :line
              ganglia_graph.vertical_label = "Time in ms"
              ganglia_graph.size = "xlarge"
              ganglia_graph.legend = true
            end

            section.ganglia_graph :"#{name}_#{dimension}_cache_hits_and_misses", :title => "#{dimension.to_s.titleize} Cache Hits and Misses" do |ganglia_graph|
              ganglia_graph.hosts = instance[:host]
              ganglia_graph.metrics = "^#{dimension}_dimension_cache_.*_count"
              ganglia_graph.type = :line
              ganglia_graph.size = "xlarge"
              ganglia_graph.legend = true
            end

            section.ganglia_graph :"#{name}_#{dimension}_creation_rate", :title => "#{dimension.to_s.titleize} Creation Rate" do |ganglia_graph|
              ganglia_graph.hosts = instance[:host]
              ganglia_graph.metrics = "#{dimension}_dimension_create_time.rate.mean"
              ganglia_graph.type = :line
              ganglia_graph.size = "xlarge"
              ganglia_graph.legend = true
            end
          end
        end
      end
    end
  end
end