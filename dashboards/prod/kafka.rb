require 'dashboards/boulder/hadoop'

PROD_SITES.each do |name, site|
  GDash::Dashboard.define :"#{name}" do |dashboard|
    dashboard.dashboard :"#{site[:prefix]}_kafka" do |kafka|
      kafka.title = "Kafka"
      kafka.description = "Kafka cluster"

      kafka.system_section "Kafka", site[:prefix]

      kafka.section :title => "Mirror Maker Lags", :width => 3 do |lags|
        lags.ganglia_graph :"#{site[:prefix]}_mirror_maker_lags", :title => "All" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-01"
          ganglia_graph.metrics = "consumer.kafka-mirror-group.[^\\.]+.lag"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        KAFKA_PROD_TOPICS.each do |topic|
          lags.ganglia_graph :"#{site[:prefix]}_#{topic}_lags", :title => topic do |ganglia_graph|
            ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
            ganglia_graph.metrics = "consumer.kafka-mirror-group.#{topic}.broker\\d+.partition\\d+.lag"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end

      kafka.section :title => "Kafka", :width => 3 do |section|
        section.ganglia_graph :"#{site[:prefix]}_kafka_messages_in", :title => "Messages In" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.MessagesIn"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :"#{site[:prefix]}_kafka_bytes_out", :title => "Bytes Out" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerAllTopicStat.BytesOut"
          ganglia_graph.type = :stack
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :"#{site[:prefix]}_kafka_heap_used", :title => "Heap Used" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :"#{site[:prefix]}_kafka_disk_writes", :title => "Disk Writes" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :"#{site[:prefix]}_kafka_disk_reads", :title => "Disk Reads" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "diskstat_sda_read_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :"#{site[:prefix]}_kafka_disk_free", :title => "Disk Free" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
          ganglia_graph.metrics = "disk_free$"
          ganglia_graph.vertical_label = "GB Free"
          ganglia_graph.size = "xlarge"
        end
      end

      KAFKA_PROD_TOPICS.each do |topic|
        kafka.section :title => "Topic: #{topic}", :width => 3 do |section|
          section.ganglia_graph :"#{site[:prefix]}_kafka_#{topic}_messages_in", :title => "Messages In" do |ganglia_graph|
            ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.MessagesIn"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end

          section.ganglia_graph :"#{site[:prefix]}_kafka_#{topic}_bytes_in", :title => "Bytes In" do |ganglia_graph|
            ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesIn"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end

          section.ganglia_graph :"#{site[:prefix]}_kafka_#{topic}_bytes_out", :title => "Bytes Out" do |ganglia_graph|
            ganglia_graph.hosts = "#{site[:prefix]}-kafka-0[123]"
            ganglia_graph.metrics = "kafka.server.BrokerTopicStat.kafka.BrokerTopicStat.#{topic}.BytesOut"
            ganglia_graph.type = :stack
            ganglia_graph.size = "xlarge"
          end
        end
      end
    end
  end
end
