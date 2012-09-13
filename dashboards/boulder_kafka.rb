GDash::Dashboard.define :boulder_kafka do |dashboard|
  dashboard.title = "Boulder Kafka"
  dashboard.description = "Local Kafka cluster in Boulder"
  dashboard.ganglia_host = "http://bld-mon-03/ganglia"

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

  dashboard.section :title => "Kafka", :width => 3 do |section|
    section.ganglia_graph :title => "Messages In" do |ganglia_graph|
      ganglia_graph.hosts = "bld-kafka-0[123]"
      ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
      ganglia_graph.type = :stack
      ganglia_graph.size = "xlarge"
    end

    section.ganglia_graph :title => "Disk Writes" do |ganglia_graph|
      ganglia_graph.hosts = "bld-kafka-0[123]"
      ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
      ganglia_graph.size = "xlarge"
    end

    section.ganglia_graph :title => "Heap Used" do |ganglia_graph|
      ganglia_graph.hosts = "bld-kafka-0[123]"
      ganglia_graph.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
      ganglia_graph.size = "xlarge"
    end
  end

  ["prod-a2", "prod-beacon", "prod-server-start", "prod-server-end", "trial-server-start", "trial_server-end", "dev-server-start", "dev-server-end", "test-server-start", "test-server-end"].each do |topic|
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
