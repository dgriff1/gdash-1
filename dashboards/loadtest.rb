GDash::Dashboard.define :bld_loadtest do |dashboard|
  #dashboard.parent = :boulder
  dashboard.title = "Boulder Loadtest"
  dashboard.description = "LoadTest Hosts & Services"
  dashboard.ganglia_host = "http://bld-mon-03.f4tech.com/"

  dashboard.dashboard :"loadtest_alm_compare" do |alm_compare|
    alm_compare.title = "ALM Host Comparison"
    
    alm_compare.section :title => "Key Metric Comparison", :width => 5 do |compare| 
      [
        "dsc-loadtestapp-01.f4tech.com", 
        "dsc-loadtestapp-02.f4tech.com", 
        "dsc-loadtestapp-03.f4tech.com", 
        "dsc-loadtestapp-04.f4tech.com", 
        "dsc-loadtestapp-05.f4tech.com"
      ].each do |host|

        compare.ganglia_report :title => "Load" do |ganglia_report|
          ganglia_report.report = "load_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "medium"
        end

        compare.ganglia_report :title => "Request Rate" do |ganglia_report|
          ganglia_report.report = "slm_request_rate_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        compare.ganglia_report :title => "Response Time" do |ganglia_report|
          ganglia_report.report = "slm_response_time_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        compare.ganglia_report :title => "ALM Connections" do |ganglia_report|
          ganglia_report.report = "slm_connections_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        compare.ganglia_report :title => "NewGen GC" do |ganglia_report|
          ganglia_report.report = "slm_new_gen_gc_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

      end # End of host block
    end # End of compare section
  end # End of compare dashboard

  dashboard.dashboard :"loadtest_alm" do |alm_dash|
    alm_dash.title = "ALM App Server Detail"
      [
        "dsc-loadtestapp-01.f4tech.com", 
        "dsc-loadtestapp-02.f4tech.com", 
        "dsc-loadtestapp-03.f4tech.com", 
        "dsc-loadtestapp-04.f4tech.com", 
        "dsc-loadtestapp-05.f4tech.com"
      ].each do |host|

      alm_dash.section :title => "#{host} System Stats", :width => 4 do |system|

        system.ganglia_report :title => "Network Usage" do |ganglia_report|
          ganglia_report.report = "network_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "medium"
        end

        system.ganglia_report :title => "Load" do |ganglia_report|
          ganglia_report.report = "load_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "medium"
        end

        system.ganglia_report :title => "CPU" do |ganglia_report|
          ganglia_report.report = "cpu_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "medium"
        end

        system.ganglia_report :title => "Memory" do |ganglia_report|
          ganglia_report.report = "mem_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "medium"
        end
      end # End of system stats

      alm_dash.section :title => "#{host} - ALM", :width => 2 do |alm|
        alm.ganglia_report :title => "Request Rate" do |ganglia_report|
          ganglia_report.report = "slm_request_rate_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Response Time" do |ganglia_report|
          ganglia_report.report = "slm_response_time_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "ALM Sessions" do |ganglia_report|
          ganglia_report.report = "slm_sessions_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Jetty Threads" do |ganglia_report|
          ganglia_report.report = "slm_jetty_threads_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Full GC" do |ganglia_report|
          ganglia_report.report = "slm_full_gc_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "NewGen GC" do |ganglia_report|
          ganglia_report.report = "slm_new_gen_gc_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Cache Hit/Miss" do |ganglia_report|
          ganglia_report.report = "slm_cache_hit_miss_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Message Queue Sizes" do |ganglia_report|
          ganglia_report.report = "slm_message_queue_sizes_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Message Process Rates" do |ganglia_report|
          ganglia_report.report = "slm_message_process_rates_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Notification Processing Performance" do |ganglia_report|
          ganglia_report.report = "slm_notifications_processed_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Atifact Change %" do |ganglia_report|
          ganglia_report.report = "slm_artifacts_changed_per_request_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Atifact Indexing Performance" do |ganglia_report|
          ganglia_report.report = "slm_artifact_indexing_performance_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        alm.ganglia_report :title => "Quartz Connections" do |ganglia_report|
          ganglia_report.report = "slm_quartz_connections_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

      end # End of ALM Metrics

      alm_dash.section :title => "#{host} - Analytics", :width => 2 do |analytics|
        analytics.ganglia_report :title => "Request Rate" do |ganglia_report|
          ganglia_report.report = "analytics_request_rate_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        analytics.ganglia_report :title => "Response Time" do |ganglia_report|
          ganglia_report.report = "analytics_response_time_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end

        analytics.ganglia_report :title => "ALM Sessions" do |ganglia_report|
          ganglia_report.report = "slm_sessions_report"
          ganglia_report.cluster = "Loadtest"
          ganglia_report.host = host
          ganglia_report.size = "large"
        end
      end # End of Analytics Metrics

    end # End of host each block

  end # End of ALM Dashboard

  # dashboard.dashboard :"#{site[:prefix]}_kafka" do |kafka|
  #   kafka.title = "Kafka"
  #   kafka.description = "Kafka cluster"

  #   kafka.section :title => "System", :width => 4 do |section|
  #     section.ganglia_report :title => "Load Average" do |ganglia_report|
  #       ganglia_report.report = "load_report"
  #       ganglia_report.cluster = "Kafka"
  #       ganglia_report.size = "large"
  #     end

  #     section.ganglia_report :title => "CPU Usage" do |ganglia_report|
  #       ganglia_report.report = "cpu_report"
  #       ganglia_report.cluster = "Kafka"
  #       ganglia_report.size = "large"
  #     end

  #     section.ganglia_report :title => "Network Usage" do |ganglia_report|
  #       ganglia_report.report = "network_report"
  #       ganglia_report.cluster = "Kafka"
  #       ganglia_report.size = "large"
  #     end

  #     section.ganglia_report :title => "Memory Usage" do |ganglia_report|
  #       ganglia_report.report = "mem_report"
  #       ganglia_report.cluster = "Kafka"
  #       ganglia_report.size = "large"
  #     end
  #   end

  #   kafka.section :title => "Kafka", :width => 3 do |section|
  #     section.ganglia_graph :title => "Messages In" do |ganglia_graph|
  #       ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
  #       ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
  #       ganglia_graph.type = :stack
  #       ganglia_graph.size = "xlarge"
  #     end

  #     section.ganglia_graph :title => "Heap Used" do |ganglia_graph|
  #       ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
  #       ganglia_graph.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
  #       ganglia_graph.size = "xlarge"
  #     end

  #     section.ganglia_graph :title => "Disk Writes" do |ganglia_graph|
  #       ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
  #       ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
  #       ganglia_graph.size = "xlarge"
  #     end

  #     section.ganglia_graph :title => "Disk Reads" do |ganglia_graph|
  #       ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
  #       ganglia_graph.metrics = "diskstat_sda_read_bytes_per_sec"
  #       ganglia_graph.size = "xlarge"
  #     end

  #     section.ganglia_graph :title => "Disk Free" do |ganglia_graph|
  #       ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
  #       ganglia_graph.metrics = "disk_free$"
  #       ganglia_graph.vertical_label = "GB Free"
  #       ganglia_graph.size = "xlarge"
  #     end
  #   end

  #   ["prod-a2", "prod-beacon", "prod-server-start", "prod-server-end", "trial-server-start", "trial_server-end"].each do |topic|
  #     kafka.section :title => "Topic: #{topic}", :width => 3 do |section|
  #       section.ganglia_graph :title => "Messages In" do |ganglia_graph|
  #         ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
  #         ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
  #         ganglia_graph.type = :stack
  #         ganglia_graph.size = "xlarge"
  #       end

  #       section.ganglia_graph :title => "Bytes In" do |ganglia_graph|
  #         ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
  #         ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
  #         ganglia_graph.type = :stack
  #         ganglia_graph.size = "xlarge"
  #       end

  #       section.ganglia_graph :title => "Bytes Out" do |ganglia_graph|
  #         ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
  #         ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
  #         ganglia_graph.type = :stack
  #         ganglia_graph.size = "xlarge"
  #       end
  #     end
  #   end
  # end

  # dashboard.dashboard :"#{site[:prefix]}_zookeeper" do |zookeeper|
  #   zookeeper.title = "ZooKeeper"
  #   zookeeper.description = "ZooKeeper cluster"

  #   zookeeper.section :title => "System", :width => 4 do |section|
  #     section.ganglia_report :title => "Load Average" do |ganglia_report|
  #       ganglia_report.report = "load_report"
  #       ganglia_report.cluster = "Zookeeper"
  #       ganglia_report.size = "large"
  #     end

  #     section.ganglia_report :title => "CPU Usage" do |ganglia_report|
  #       ganglia_report.report = "cpu_report"
  #       ganglia_report.cluster = "Zookeeper"
  #       ganglia_report.size = "large"
  #     end

  #     section.ganglia_report :title => "Network Usage" do |ganglia_report|
  #       ganglia_report.report = "network_report"
  #       ganglia_report.cluster = "Zookeeper"
  #       ganglia_report.size = "large"
  #     end

  #     section.ganglia_report :title => "Memory Usage" do |ganglia_report|
  #       ganglia_report.report = "mem_report"
  #       ganglia_report.cluster = "Zookeeper"
  #       ganglia_report.size = "large"
  #     end
  #   end

  #   zookeeper.section :title => "Cluster", :width => 2 do |section|
  #     section.ganglia_graph :title => "Heap Used" do |report|
  #       report.hosts = "#{site[:prefix]}-zookeeper-0[123]"
  #       report.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
  #       report.size = "xlarge"
  #     end

  #     section.ganglia_graph :title => "Disk Writes" do |ganglia_graph|
  #       ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
  #       ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
  #       ganglia_graph.size = "xlarge"
  #     end

  #     section.ganglia_graph :title => "Outstanding Requests" do |ganglia_graph|
  #       ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
  #       ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.OutstandingRequests"
  #       ganglia_graph.size = "xlarge"
  #     end

  #     section.ganglia_graph :title => "Latency" do |ganglia_graph|
  #       ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
  #       ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.LastLatency"
  #       ganglia_graph.size = "xlarge"
  #     end
  #   end

  #   ["#{site[:prefix]}-zookeeper-01", "#{site[:prefix]}-zookeeper-02", "#{site[:prefix]}-zookeeper-03"].each do |host|
  #     zookeeper.section :title => "Host: #{host}", :width => 4 do |section|
  #       section.ganglia_report do |graph|
  #         graph.report = "zk_connection_throughput_report"
  #         graph.cluster = "Zookeeper"
  #         graph.host = "#{host}.rally.prod"
  #         graph.size = "xlarge"
  #       end

  #       section.ganglia_report do |ganglia_report|
  #         ganglia_report.report = "zk_connection_latency_report"
  #         ganglia_report.cluster = "Zookeeper"
  #         ganglia_report.host = "#{host}.rally.prod"
  #         ganglia_report.size = "xlarge"
  #       end

  #       section.ganglia_report do |ganglia_report|
  #         ganglia_report.report = "zk_leader_follower_latency_report"
  #         ganglia_report.cluster = "Zookeeper"
  #         ganglia_report.host = "#{host}.rally.prod"
  #         ganglia_report.size = "xlarge"
  #       end
  #     end
  #   end
  # end

end # End of site Dashboard