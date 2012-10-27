PROD_SITES = {
  :qd => {
    :title => "Denver",
    :prefix => "qd",
    :data_center => :denver,
    :app_servers => (1..5).map { |n| "qd-app-0#{n}.rally.prod" },
    :zookeeper_servers => (1..3).map { |n| "qd-zookeeper-0#{n}.rally.prod" },
    :kafka_servers => (1..3).map { |n| "qd-kafka-0#{n}.rally.prod" },
    :cacti_bandwidth_fw01 => {
      :graph_id => 542,
      :rra_id => 0
    },
    :cacti_bandwidth_fw02 => {
      :graph_id => 575,
      :rra_id => 0
    }
  }, 
  :qs => {
    :title => "Seattle",
    :prefix => "qs",
    :data_center => :seattle,
    :app_servers => (1..5).map { |n| "qs-app-0#{n}.rally.prod" },
    :zookeeper_servers => (1..3).map { |n| "qs-zookeeper-0#{n}.rally.prod" },
    :kafka_servers => (1..3).map { |n| "qs-kafka-0#{n}.rally.prod" },
    :cacti_bandwidth_fw01 => {
      :graph_id => 542,
      :rra_id => 0
    },
    :cacti_bandwidth_fw02 => {
      :graph_id => 575,
      :rra_id => 0
    }
  } 
}

require 'dashboards/prod/host_comparison'
require 'dashboards/prod/kafka'
require 'dashboards/prod/zookeeper'

PROD_SITES.each do |name, site|
  GDash::Dashboard.define :"#{name}" do |dashboard|
    dashboard.title = site[:title]
    dashboard.description = "#{site[:title]} Hosts & Services"
    dashboard.data_center = site[:data_center]

    dashboard.section :title => "Key Metrics", :width => 2 do |key_metrics|
      key_metrics.cacti_graph :"#{site[:prefix]}_throughput_fw01", :title => "#{site[:title]} Throughput fw01" do |cacti_graph|
        cacti_graph.graph_id = site[:cacti_bandwidth_fw01][:graph_id]
        cacti_graph.rra_id = site[:cacti_bandwidth_fw01][:rra_id]
      end

      key_metrics.cacti_graph :"#{site[:prefix]}_throughput_fw02", :title => "#{site[:title]} Throughput fw02" do |cacti_graph|
        cacti_graph.graph_id = site[:cacti_bandwidth_fw02][:graph_id]
        cacti_graph.rra_id = site[:cacti_bandwidth_fw02][:rra_id]
      end

      key_metrics.ganglia_report :"#{site[:prefix]}_alm_request_rate", :title => "ALM Request Rate" do |ganglia_report|
        ganglia_report.report = "slm_request_rate_report"
        ganglia_report.cluster = "ALM"
        ganglia_report.size = "xlarge"
      end

      key_metrics.ganglia_report :"#{site[:prefix]}_alm_response_time", :title => "ALM Response Time" do |ganglia_report|
        ganglia_report.report = "slm_response_time_report"
        ganglia_report.cluster = "ALM"
        ganglia_report.size = "xlarge"
      end

      #key_metrics.ganglia_graph :"#{site[:prefix]}_analytics_request_rate", :title => "Analytics Request Rate" do |ganglia_graph|
      #  ganglia_graph.metrics = "analytics.org.mortbay.jetty.handler.StatisticsHandler.statisticshandler.0.requests$"
      #  ganglia_graph.type = :stack
      #  ganglia_graph.size = "xlarge"
      #end

      key_metrics.ganglia_report :"#{site[:prefix]}_analytics_response_time", :title => "Analytics Response Time" do |ganglia_report|
        ganglia_report.report = "analytics_response_time_report"
        ganglia_report.cluster = "ALM"
        ganglia_report.size = "xlarge"
      end
    end
  end
end
