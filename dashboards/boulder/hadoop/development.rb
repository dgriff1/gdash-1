GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.dashboard :hadoop do |hadoop|
    hadoop.dashboard :dev_hadoop do |dashboard|
      dashboard.title = "Development"
      dashboard.description = "Development Hadoop cluster (Mac Pros)"

      dashboard.system_section "Boulder Hadoop", "development_kafka"

      dashboard.table({ :name => :development_kafka_messages_in, :title => "Messages In", :metric => "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn" },
                      { :name => :development_kafka_bytes_in,    :title => "Bytes In",    :metric => "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesIn" },
                      { :name => :development_kafka_bytes_out,   :title => "Bytes Out",   :metric => "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesOut" },
                      :title => "Kafka", :width => 3) do |section, options|
        section.ganglia_graph options[:name], :title => options[:title] do |graph|
          graph.hosts = "bld-hadoop-0[123]"
          graph.metrics = options[:metric]
          graph.type = :stack
          graph.size = "xlarge"
        end
      end

      dashboard.section :title => "Mirror Maker Lags", :width => 3 do |lags|
        lags.ganglia_graph :development_kafka_lag, :title => "All" do |ganglia_graph|
          ganglia_graph.hosts = "bld-hadoop-01"
          ganglia_graph.metrics = "consumer.kafka-mirror-group.[^\\.]+.lag"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        KAFKA_TOPICS.each do |topic|
          lags.ganglia_graph :"development_kafka_#{topic}_lag", :title => "#{topic}" do |ganglia_graph|
            ganglia_graph.hosts = "bld-hadoop-0[123]"
            ganglia_graph.metrics = "consumer.kafka-mirror-group.#{topic}.broker\\d+.partition\\d+.lag"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end

      KAFKA_TOPICS.each do |topic|
        dashboard.table({ :name => :"development_kafka_#{topic}_messages_in", :title => "Messages In", :metric => "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn" },
                        { :name => :"development_kafka_#{topic}_bytes_in",    :title => "Bytes In",    :metric => "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn" },
                        { :name => :"development_kafka_#{topic}_bytes_out",   :title => "Bytes Out",   :metric => "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut" },
                        :title => "Topic: #{topic}", :width => 3) do |section, options|
          section.ganglia_graph options[:name], :title => options[:title] do |ganglia_graph|
            ganglia_graph.hosts = "bld-hadoop-0[123]"
            ganglia_graph.metrics = options[:metric]
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end
    end
  end
end