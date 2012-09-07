GDash::Dashboard.new :boulder_hadoop do |dashboard|
  dashboard.title = "Boulder Hadoop"
  dashboard.description = "Development Hadoop cluster in Boulder (Mac Pros)"

  dashboard.section :title => "Cluster Kafka Metrics", :width => 2 do |section|
    section.graph :title => "Messages In" do |graph|
      graph.hosts = "bld-hadoop-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
      graph.type = :stacked
    end

    section.graph :title => "Bytes In" do |graph|
      graph.hosts = "bld-hadoop-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
      graph.type = :stacked
    end

    section.graph :title => "Bytes Out" do |graph|
      graph.hosts = "bld-hadoop-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
      graph.type = :stacked
    end
  end

  ["prod-a2", "prod-beacon", "prod-server", "trial-server"].each do |topic|
    dashboard.section :title => "Kafka Topic: #{topic}", :width => 3 do |section|
      section.graph :title => "Messages In" do |graph|
        graph.hosts = "bld-hadoop-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
        graph.type = :stacked
      end

      section.graph :title => "Bytes In" do |graph|
        graph.hosts = "bld-hadoop-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
        graph.type = :stacked
      end

      section.graph :title => "Bytes Out" do |graph|
        graph.hosts = "bld-hadoop-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
        graph.type = :stacked
      end
    end
  end
end
