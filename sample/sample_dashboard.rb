GDash::Dashboard.new :boulder_kafka do |dashboard|
  dashboard.title = "Boulder Kafka"
  dashboard.description = "Local Kafka cluster in Boulder"

  dashboard.section :title => "Cluster Metrics", :width => 3 do |section|
    section.graph :title => "Messages In" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
    end

    section.graph :title => "Bytes In" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
    end

    section.graph :title => "Bytes Out" do |graph|
      graph.hosts = "bld-kafka-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
    end
  end

  ["prod-a2", "prod-beacon", "prod-server", "trial-server"].each do |topic|
    dashboard.section :title => "Topic: #{topic}", :width => 3 do |section|
      section.graph :title => "Messages In" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
      end

      section.graph :title => "Bytes In" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
      end

      section.graph :title => "Bytes Out" do |graph|
        graph.hosts = "bld-kafka-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
      end
    end
  end
end