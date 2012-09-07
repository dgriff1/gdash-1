GDash::Dashboard.new :boulder_kafka do |dashboard|
  dashboard.title = "Boulder Kafka"
  dashboard.description = "Local Kafka cluster in Boulder"

  dashboard.section :title => "Cluster Metrics", :width => 3 do |section|
    section.graph :title => "Messages In" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
      graph.type = :stacked
    end

    section.graph :title => "Bytes In" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
      graph.type = :stacked
    end

    section.graph :title => "Bytes Out" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
      graph.type = :stacked
    end
  end

  ["prod-a2", "prod-beacon", "prod-server", "trial-server"].each do |topic|
    dashboard.section :title => "Topic: #{topic}", :width => 3 do |section|
      section.graph :title => "Messages In" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
        graph.type = :stacked
      end

      section.graph :title => "Bytes In" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
        graph.type = :stacked
      end

      section.graph :title => "Bytes Out" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
        graph.type = :stacked
      end
    end
  end
end
