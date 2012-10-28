ZUUL_SITES = {
  :qd => {
    :title => "Denver",
    :prefix => "qd",
    :data_center => :denver,
    :hosts => (1..3).map { |n| "qd-zuul-01.rally.prod" }
  }, 
  :qs => {
    :title => "Seattle",
    :prefix => "qs",
    :data_center => :seattle,
    :hosts => (1..3).map { |n| "qs-zuul-01.rally.prod" }
  } 
}

require 'zuul/compare'
require 'zuul/detail'

ZUUL_SITES.each do |name, site|
  GDash::Dashboard.toplevel name do |zuul_site|
    zuul_site.dashboard :"#{name}_zuul_top" do |dashboard|
      dashboard.title = "Zuul"
      dashboard.description = "#{site[:title]} Zuul metrics"
      dashboard.data_center = site[:data_center]

      dashboard.section :title => "Key Metrics", :width => 2 do |key_metrics|
        key_metrics.ganglia_report :"#{site[:prefix]}_zuul_request_rate", :title => "Zuul Request Rate" do |ganglia_report|
          ganglia_report.report = "zuul_request_rate_report"
          ganglia_report.cluster = "Zuul"
          ganglia_report.size = "xlarge"
        end

        key_metrics.ganglia_report :"#{site[:prefix]}_zuul_response_time", :title => "Zuul Response Time" do |ganglia_report|
          ganglia_report.report = "zuul_request_time_report"
          ganglia_report.cluster = "Zuul"
          ganglia_report.size = "xlarge"
        end

        key_metrics.ganglia_graph :"#{site[:prefix]}_zuul_exception_rate", :title => "Zuul Exception Rate" do |graph|
          graph.hosts = "#{site[:prefix]}-zuul-*"
          graph.metrics = "zuul.service.unexpected.1MinuteRate"
          graph.type = :stack
          graph.size = "xlarge"
          graph.legend = true
        end
      end
    end
  end
end
