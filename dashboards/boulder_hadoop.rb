GDash::Dashboard.new :boulder_hadoop do |dashboard|
  dashboard.title = "Boulder Hadoop"
  dashboard.description = "Development Hadoop cluster in Boulder (Mac Pros)"
  dashboard.ganglia_host = "http://bld-mon-03/ganglia"

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
    end

    section.ganglia_graph :title => "Bytes In" do |graph|
      graph.hosts = "bld-hadoop-0[123]"
      graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
      graph.type = :stack
    end

    section.ganglia_graph :title => "Bytes Out" do |ganglia_graph|
      ganglia_graph.hosts = "bld-hadoop-0[123]"
      ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn"
      ganglia_graph.type = :stack
    end
  end

  ["prod-a2", "prod-beacon", "prod-server", "trial-server"].each do |topic|
    dashboard.section :title => "Topic: #{topic}", :width => 3 do |section|
      section.ganglia_graph :title => "Messages In" do |ganglia_graph|
        ganglia_graph.hosts = "bld-hadoop-0[123]"
        ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
        ganglia_graph.type = :stack
      end

      section.ganglia_graph :title => "Bytes In" do |graph|
        graph.hosts = "bld-hadoop-0[123]"
        graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
        graph.type = :stack
      end

      section.ganglia_graph :title => "Bytes Out" do |ganglia_graph|
        ganglia_graph.hosts = "bld-hadoop-0[123]"
        ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
        ganglia_graph.type = :stack
      end
    end
  end
end
