$: << File.join(File.dirname(__FILE__), "lib")

require 'bundler/setup'

require 'gdash'

set :run, false

config = YAML.load_file(File.expand_path("../config/gdash.yaml", __FILE__))

# If you want basic HTTP authentication
# include :username and :password in gdash.yaml
if config[:username] && config[:password]
  use Rack::Auth::Basic do |username, password|
    username == config[:username] && password == config[:password]
  end
end

# run GDash::SinatraApp.new(config[:graphite], config[:templatedir], config[:options])

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

run GDash::App
