GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.dashboard :hadoop do |hadoop|
    hadoop.dashboard :boulder_kafka do |dashboard|
      dashboard.title = "Kafka"
      dashboard.description = "Kafka cluster"

      dashboard.section :title => "Nagios", :width => 1 do |nagios|
        nagios.nagios "kafka-servers"
      end

      dashboard.system_section "Boulder Kafka", "boulder_kafka"

      dashboard.section :title => "Kafka", :width => 3 do |section|
        section.ganglia_graph :boulder_kafka_messages_in, :title => "Messages In" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :boulder_kafka_bytes_out, :title => "Bytes Out" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesOut"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :boulder_kafka_heap_used, :title => "Heap Used" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :boulder_kafka_disk_writes, :title => "Disk Writes" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :boulder_kafka_disk_reads, :title => "Disk Reads" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "diskstat_sda_read_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :boulder_kafka_disk_free, :title => "Disk Free" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-0[123]"
          ganglia_graph.metrics = "disk_free$"
          ganglia_graph.vertical_label = "GB Free"
          ganglia_graph.size = "xlarge"
        end
      end

      dashboard.section :title => "Mirror Maker Lags", :width => 3 do |lags|
        lags.ganglia_graph :boulder_kafka_lag, :title => "All" do |ganglia_graph|
          ganglia_graph.hosts = "bld-kafka-01"
          ganglia_graph.metrics = "consumer.kafka-mirror-group.[^\\.]+.lag"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        KAFKA_TOPICS.each do |topic|
          lags.ganglia_graph :"boulder_kafka_#{topic}_lag", :title => "#{topic}" do |ganglia_graph|
            ganglia_graph.hosts = "bld-kafka-0[123]"
            ganglia_graph.metrics = "consumer.kafka-mirror-group.#{topic}.broker\\d+.partition\\d+.lag"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end

      KAFKA_TOPICS.each do |topic|
        dashboard.table({ :name => :"boulder_kafka_#{topic}_messages_in", :title => "Messages In", :metric => "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn" },
                        { :name => :"boulder_kafka_#{topic}_bytes_in", :title => "Bytes In", :metric => "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn" },
                        { :name => :"boulder_kafka_#{topic}_bytes_out", :title => "Bytes Out", :metric => "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut" },
                        :title => "Topic: #{topic}", :width => 3) do |section, options|
          section.ganglia_graph options[:name], :title => options[:title] do |ganglia_graph|
            ganglia_graph.hosts = "bld-kafka-0[123]"
            ganglia_graph.metrics = options[:metric]
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end
    end
  end
end