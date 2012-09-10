GDash::Dashboard.new :boulder_kafka do |dashboard|
  dashboard.title = "Boulder Kafka"
  dashboard.description = "Local Kafka cluster in Boulder"
  dashboard.ganglia_host = "http://bld-mon-03/ganglia"

  dashboard.section :title => "System", :width => 2 do |section|
    section.report :title => "CPU Usage" do |report|
      report.report = "cpu_report"
      report.cluster = "Boulder Kafka"
    end

    section.report :title => "Network Usage" do |report|
      report.report = "network_report"
      report.cluster = "Boulder Kafka"
    end
  end

  dashboard.section :title => "Kafka", :width => 3 do |section|
    section.graph :title => "Messages In" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
      graph.type = :stack
    end

    section.graph :title => "Bytes In" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
      graph.type = :stack
    end

    section.graph :title => "Bytes Out" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
      graph.type = :stack
    end
  end

  ["prod-a2", "prod-beacon", "prod-server", "trial-server"].each do |topic|
    dashboard.section :title => "Topic: #{topic}", :width => 3 do |section|
      section.graph :title => "Messages In" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
        graph.type = :stack
      end

      section.graph :title => "Bytes In" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
        graph.type = :stack
      end

      section.graph :title => "Bytes Out" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
        graph.type = :stack
      end
    end
  end
end
