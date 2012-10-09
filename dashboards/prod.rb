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
    dashboard.cacti_host = "http://bld-mon-03.f4tech.com/cacti-#{site[:prefix]}"

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

    dashboard.dashboard :"#{site[:prefix]}_alm_compare" do |alm_compare|
      alm_compare.title = "ALM Host Comparison"
      
      alm_compare.section :title => "Key Metric Comparison", :width => 5 do |compare| 
        [
          "#{site[:prefix]}-app-01.rally.prod", 
          "#{site[:prefix]}-app-02.rally.prod", 
          "#{site[:prefix]}-app-03.rally.prod", 
          "#{site[:prefix]}-app-04.rally.prod", 
          "#{site[:prefix]}-app-05.rally.prod"
        ].each do |host|
          [
            ["Load", "load_report"],
            ["Request Rate", "slm_request_rate_report"],
            ["Response Time", "slm_response_time_report"],
            ["ALM Connections", "slm_connections_report"],
            ["JVM Memory", "slm_all_jvm_memory_report"]
          ].each do |(title, report)|
            compare.ganglia_report :title => "#{title}" do |ganglia_report|
              ganglia_report.report = "#{report}"
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end
          end # End of metric block
        end # End of host block
      end # End of compare section

      [
        "#{site[:prefix]}-app-01.rally.prod", 
        "#{site[:prefix]}-app-02.rally.prod", 
        "#{site[:prefix]}-app-03.rally.prod", 
        "#{site[:prefix]}-app-04.rally.prod", 
        "#{site[:prefix]}-app-05.rally.prod"
      ].each do |host|
        alm_compare.dashboard :"#{site[:prefix]}_alm_#{host}" do |alm_dash|
          alm_dash.title = "#{host}"
          alm_dash.section :title => "#{host} System Stats", :width => 4 do |system|

            [
              ["Network Usage", "network_report"],
              ["Load", "load_report"],
              ["CPU", "cpu_report"],
              ["Memory", "mem_report"]
            ].each do |(title, report)|
              system.ganglia_report :title => "#{title}" do |ganglia_report|
                ganglia_report.report = "#{report}"
                ganglia_report.cluster = "ALM"
                ganglia_report.host = host
                ganglia_report.size = "medium"
              end
            end
          end # End of system stats

          alm_dash.section :title => "#{host} - ALM", :width => 2 do |alm|
            [
              ["Request Rate", "slm_request_rate_report"],
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
              ["Quartz Connections", "slm_quartz_connections_report"]
            ].each do |(title, report)|
              alm.ganglia_report :title => "#{title}" do |ganglia_report|
                ganglia_report.report = "#{report}"
                ganglia_report.cluster = "ALM"  
                ganglia_report.host = host
                ganglia_report.size = "large"
              end
            end
          end # End of ALM Metrics

          alm_dash.section :title => "#{host} - Analytics", :width => 2 do |analytics|
            analytics.ganglia_report :title => "Request Rate" do |ganglia_report|
              ganglia_report.report = "analytics_request_rate_report"
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end

            analytics.ganglia_report :title => "Response Time" do |ganglia_report|
              ganglia_report.report = "analytics_response_time_report"
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end

            analytics.ganglia_report :title => "ALM Sessions" do |ganglia_report|
              ganglia_report.report = "slm_sessions_report"
              ganglia_report.cluster = "ALM"
              ganglia_report.host = host
              ganglia_report.size = "large"
            end
          end # End of Analytics Metrics

        end # End of host each block

      end # End of ALM Dashboard

    end # End of compare dashboard

    dashboard.dashboard :"#{site[:prefix]}_kafka" do |kafka|
      kafka.title = "Kafka"
      kafka.description = "Kafka cluster"

      kafka.section :title => "System", :width => 4 do |section|
        section.ganglia_report :title => "Load Average" do |ganglia_report|
          ganglia_report.report = "load_report"
          ganglia_report.cluster = "Kafka"
          ganglia_report.size = "large"
        end

        section.ganglia_report :title => "CPU Usage" do |ganglia_report|
          ganglia_report.report = "cpu_report"
          ganglia_report.cluster = "Kafka"
          ganglia_report.size = "large"
        end

        section.ganglia_report :title => "Network Usage" do |ganglia_report|
          ganglia_report.report = "network_report"
          ganglia_report.cluster = "Kafka"
          ganglia_report.size = "large"
        end

        section.ganglia_report :title => "Memory Usage" do |ganglia_report|
          ganglia_report.report = "mem_report"
          ganglia_report.cluster = "Kafka"
          ganglia_report.size = "large"
        end
      end

      kafka.section :title => "Mirror Maker Lags", :width => 3 do |lags|
        ["prod-server-start", "prod-server-end", "prod-beacon", "trial-server-start", "trial-server-end"].each do |topic|
          lags.ganglia_graph :title => "#{topic}" do |ganglia_graph|
            ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
            ganglia_graph.metrics = "consumer.kafka-mirror-group.#{topic}.broker\\d+.partition\\d+.lag"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end

      kafka.section :title => "Kafka", :width => 3 do |section|
        section.ganglia_graph :title => "Messages In" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Bytes Out" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesOut"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Heap Used" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Disk Writes" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Disk Reads" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "diskstat_sda_read_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Disk Free" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "disk_free$"
          ganglia_graph.vertical_label = "GB Free"
          ganglia_graph.size = "xlarge"
        end
      end

      ["prod-a2", "prod-beacon", "prod-server-start", "prod-server-end", "trial-server-start", "trial_server-end"].each do |topic|
        kafka.section :title => "Topic: #{topic}", :width => 3 do |section|
          section.ganglia_graph :title => "Messages In" do |ganglia_graph|
            ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end

          section.ganglia_graph :title => "Bytes In" do |ganglia_graph|
            ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end

          section.ganglia_graph :title => "Bytes Out" do |ganglia_graph|
            ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end
    end

    dashboard.dashboard :"#{site[:prefix]}_zookeeper" do |zookeeper|
      zookeeper.title = "ZooKeeper"
      zookeeper.description = "ZooKeeper cluster"

      zookeeper.section :title => "System", :width => 4 do |section|
        section.ganglia_report :title => "Load Average" do |ganglia_report|
          ganglia_report.report = "load_report"
          ganglia_report.cluster = "Zookeeper"
          ganglia_report.size = "large"
        end

        section.ganglia_report :title => "CPU Usage" do |ganglia_report|
          ganglia_report.report = "cpu_report"
          ganglia_report.cluster = "Zookeeper"
          ganglia_report.size = "large"
        end

        section.ganglia_report :title => "Network Usage" do |ganglia_report|
          ganglia_report.report = "network_report"
          ganglia_report.cluster = "Zookeeper"
          ganglia_report.size = "large"
        end

        section.ganglia_report :title => "Memory Usage" do |ganglia_report|
          ganglia_report.report = "mem_report"
          ganglia_report.cluster = "Zookeeper"
          ganglia_report.size = "large"
        end
      end

      zookeeper.section :title => "Cluster", :width => 2 do |section|
        section.ganglia_graph :title => "Heap Used" do |report|
          report.hosts = "#{site[:prefix]}-zookeeper-0[123]"
          report.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
          report.size = "xlarge"
        end

        section.ganglia_graph :title => "Disk Writes" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
          ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Outstanding Requests" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
          ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.OutstandingRequests"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :title => "Latency" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
          ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.LastLatency"
          ganglia_graph.size = "xlarge"
        end
      end

      ["#{site[:prefix]}-zookeeper-01", "#{site[:prefix]}-zookeeper-02", "#{site[:prefix]}-zookeeper-03"].each do |host|
        zookeeper.section :title => "Host: #{host}", :width => 4 do |section|
          section.ganglia_report do |graph|
            graph.report = "zk_connection_throughput_report"
            graph.cluster = "Zookeeper"
            graph.host = "#{host}.rally.prod"
            graph.size = "xlarge"
          end

          section.ganglia_report do |ganglia_report|
            ganglia_report.report = "zk_connection_latency_report"
            ganglia_report.cluster = "Zookeeper"
            ganglia_report.host = "#{host}.rally.prod"
            ganglia_report.size = "xlarge"
          end

          section.ganglia_report do |ganglia_report|
            ganglia_report.report = "zk_leader_follower_latency_report"
            ganglia_report.cluster = "Zookeeper"
            ganglia_report.host = "#{host}.rally.prod"
            ganglia_report.size = "xlarge"
          end
        end
      end
    end

  end # End of site Dashboard

end # End of site each block
