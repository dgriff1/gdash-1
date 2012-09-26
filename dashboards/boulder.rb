GDash::Dashboard.define :boulder do |boulder|
  boulder.title = "Boulder"
  boulder.description = "Servers in Boulder"
  boulder.ganglia_host = "http://bld-mon-03/ganglia"

  boulder.dashboard :hadoop do |hadoop|
    hadoop.title = "Hadoop Clusters"
    hadoop.description = "Hadoop and Friends in Boulder"

    hadoop.dashboard :dev_hadoop do |dashboard|
      dashboard.title = "Development"
      dashboard.description = "Development Hadoop cluster (Mac Pros)"

      dashboard.section :title => "System", :width => 2 do |section|
        section.ganglia_report :title => "CPU Usage" do |ganglia_report|
          ganglia_report.report = "cpu_report"
          ganglia_report.cluster = "Boulder Hadoop"
          ganglia_report.size = "xlarge"
        end

        section.ganglia_report :title => "Network Usage" do |ganglia_report|
          ganglia_report.report = "network_report"
          ganglia_report.cluster = "Boulder Hadoop"
          ganglia_report.size = "xlarge"
        end
      end

      dashboard.section :title => "Kafka", :width => 3 do |section|
        section.ganglia_graph :title => "Messages In" do |graph|
          graph.hosts = "bld-hadoop-0[123]"
          graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
          graph.type = :stack
          graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Bytes In" do |graph|
          graph.hosts = "bld-hadoop-0[123]"
          graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
          graph.type = :stack
          graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Bytes Out" do |ganglia_graph|
          ganglia_graph.hosts = "bld-hadoop-0[123]"
          ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end
      end

      ["prod-a2", "prod-beacon", "prod-server", "trial-server"].each do |topic|
        dashboard.section :title => "Topic: #{topic}", :width => 3 do |section|
          section.ganglia_graph :title => "Messages In" do |ganglia_graph|
            ganglia_graph.hosts = "bld-hadoop-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end

          section.ganglia_graph :title => "Bytes In" do |graph|
            graph.hosts = "bld-hadoop-0[123]"
            graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
            graph.type = :stack
            graph.size = "xlarge"
          end

          section.ganglia_graph :title => "Bytes Out" do |ganglia_graph|
            ganglia_graph.hosts = "bld-hadoop-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end
    end

    hadoop.dashboard :boulder_hadoop do |dashboard|
      dashboard.title = "Hadoop"
      dashboard.description = "Hadoop Cluster"

      dashboard.section :title => "System", :width => 2 do |section|
        section.ganglia_report :title => "CPU Usage" do |ganglia_report|
          ganglia_report.report = "cpu_report"
          ganglia_report.cluster = "Boulder Hadoop Revisited"
          ganglia_report.size = "xlarge"
        end

        section.ganglia_report :title => "Network Usage" do |ganglia_report|
          ganglia_report.report = "network_report"
          ganglia_report.cluster = "Boulder Hadoop Revisited"
          ganglia_report.size = "xlarge"
        end
      end
    end

    hadoop.dashboard :boulder_kafka do |dashboard|
      dashboard.title = "Kafka"
      dashboard.description = "Kafka cluster"

      dashboard.section :title => "System", :width => 3 do |section|
        section.ganglia_report :title => "CPU Usage" do |ganglia_report|
          ganglia_report.report = "cpu_report"
          ganglia_report.cluster = "Boulder Kafka"
          ganglia_report.size = "xlarge"
        end

        section.ganglia_report :title => "Network Usage" do |ganglia_report|
          ganglia_report.report = "network_report"
          ganglia_report.cluster = "Boulder Kafka"
          ganglia_report.size = "xlarge"
        end

        section.ganglia_graph :title => "Disk Free" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "disk_free$"
          ganglia_graph.vertical_label = "GB Free"
          ganglia_graph.size = "xlarge"
        end
      end

      dashboard.section :title => "Kafka", :width => 4 do |section|
        section.ganglia_graph :title => "Messages In" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
          ganglia_graph.type = :stack
        end

        section.ganglia_graph :title => "Heap Used" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
        end

        section.ganglia_graph :title => "Disk Writes" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
        end

        section.ganglia_graph :title => "Disk Reads" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "diskstat_sda_read_bytes_per_sec"
        end
      end

      ["prod-a2", "prod-beacon", "prod-server-start", "prod-server-end", "trial-server-start", "trial_server-end", "dev-server-start", "dev-server-end", "test-server-start", "test-server-end", "loadtest-server-start", "loadtest-server-end"].each do |topic|
        dashboard.section :title => "Topic: #{topic}", :width => 3 do |section|
          section.ganglia_graph :title => "Messages In" do |ganglia_graph|
            ganglia_graph.hosts = "bld-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end

          section.ganglia_graph :title => "Bytes In" do |ganglia_graph|
            ganglia_graph.hosts = "bld-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end

          section.ganglia_graph :title => "Bytes Out" do |ganglia_graph|
            ganglia_graph.hosts = "bld-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end
    end

    hadoop.dashboard :boulder_zookeeper do |dashboard|
      dashboard.title = "ZooKeeper"
      dashboard.description = "ZooKeeper cluster"

      dashboard.section :title => "System", :width => 2 do |section|
        section.ganglia_report :title => "CPU Usage" do |ganglia_report|
          ganglia_report.report = "cpu_report"
          ganglia_report.cluster = "Boulder Zookeeper"
          ganglia_report.size = "xlarge"
        end

        section.ganglia_report :title => "Network Usage" do |ganglia_report|
          ganglia_report.report = "network_report"
          ganglia_report.cluster = "Boulder Zookeeper"
          ganglia_report.size = "xlarge"
        end
      end

      dashboard.section :title => "Cluster", :width => 2 do |section|
        section.ganglia_graph :title => "Heap Used" do |report|
          report.hosts = "bld-zookeeper-0[123]"
          report.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
          report.size = "xlarge"
        end

        section.ganglia_graph :title => "Disk Writes" do |ganglia_graph|
          ganglia_graph.hosts = "bld-zookeeper-0[123]"
          ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Outstanding Requests" do |ganglia_graph|
          ganglia_graph.hosts = "bld-zookeeper-0[123]"
          ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.OutstandingRequests"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Latency" do |ganglia_graph|
          ganglia_graph.hosts = "bld-zookeeper-0[123]"
          ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.LastLatency"
          ganglia_graph.size = "xlarge"
        end
      end

      ["bld-zookeeper-01", "bld-zookeeper-02", "bld-zookeeper-03"].each do |host|
        dashboard.section :title => "Host: #{host}", :width => 4 do |section|
          section.ganglia_report do |graph|
            graph.report = "zk_connection_throughput_report"
            graph.cluster = "Boulder Zookeeper"
            graph.host = "#{host}.f4tech.com"
            graph.size = "xlarge"
          end

          section.ganglia_report do |ganglia_report|
            ganglia_report.report = "zk_connection_latency_report"
            ganglia_report.cluster = "Boulder Zookeeper"
            ganglia_report.host = "#{host}.f4tech.com"
            ganglia_report.size = "xlarge"
          end

          section.ganglia_report do |ganglia_report|
            ganglia_report.report = "zk_leader_follower_latency_report"
            ganglia_report.cluster = "Boulder Zookeeper"
            ganglia_report.host = "#{host}.f4tech.com"
            ganglia_report.size = "xlarge"
          end
        end
      end
    end
  end

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
          ganglia_graph.legend = true
        end

        section.ganglia_graph :title => "RabbitMQ Queues" do |ganglia_graph|
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

        [:build_version_run, :component,       :date,
         :event,             :gesture_request, :host,
         :integration,       :page,            :project,
         :proxy_remote_host, :remote_host,     :session,
         :subscriber,        :subscription,    :time,
         :tps_view,          :trace,           :unhandled_exception,
         :user_agent,        :wsapi].each do |dimension|
          dimensions.section :title => dimension.to_s.titleize, :width => 3 do |section|
            section.ganglia_graph :title => "#{dimension.to_s.titleize} Times" do |ganglia_graph|
              ganglia_graph.hosts = instance[:host]
              ganglia_graph.metrics = "^#{dimension}_dimension_.*_time.duration.mean"
              ganglia_graph.type = :line
              ganglia_graph.vertical_label = "Time in ms"
              ganglia_graph.size = "xlarge"
              ganglia_graph.legend = true
            end

            section.ganglia_graph :title => "#{dimension.to_s.titleize} Cache Hits and Misses" do |ganglia_graph|
              ganglia_graph.hosts = instance[:host]
              ganglia_graph.metrics = "^#{dimension}_dimension_cache_.*_count"
              ganglia_graph.type = :line
              ganglia_graph.size = "xlarge"
              ganglia_graph.legend = true
            end

            section.ganglia_graph :title => "#{dimension.to_s.titleize} Creation Rate" do |ganglia_graph|
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