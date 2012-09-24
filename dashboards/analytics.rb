{ "denver" => "qd",
  "seattle"  => "qs"}.each do |datacenter, site|
    GDash::Dashboard.define :"analytics_#{datacenter}" do |dashboard|
      dashboard.title = "#{datacenter.titleize} Analytics"
      dashboard.description = "Analytics Application Servers in #{datacenter.titleize}"
      dashboard.ganglia_host = "http://bld-mon-03.f4tech.com/ganglia-#{site}"

    ["#{site}-app-01.rally.prod", "#{site}-app-02.rally.prod", "#{site}-app-03.rally.prod", "#{site}-app-04.rally.prod", "#{site}-app-05.rally.prod"].each do |host|
      dashboard.section :title => "#{host}", :width => 2 do |section|

        section.ganglia_graph :title => "Request Rate" do |graph|
          graph.hosts = host
          graph.metrics = "analytics.org.mortbay.jetty.handler.StatisticsHandler.statisticshandler.0.requests$"
          graph.type = :stack
          graph.size = "xlarge"
        end

        section.ganglia_report :title => "Response Time" do |ganglia_report|
          ganglia_report.report = "analytics_response_time_report"
          ganglia_report.cluster = "ALM"
          ganglia_report.host = host
          ganglia_report.size = "xlarge"
        end

        section.ganglia_report :title => "Network Usage" do |ganglia_report|
          ganglia_report.report = "network_report"
          ganglia_report.cluster = "ALM"
          ganglia_report.host = host
          ganglia_report.size = "xlarge"
        end

        section.ganglia_report :title => "Load" do |ganglia_report|
          ganglia_report.report = "load_report"
          ganglia_report.cluster = "ALM"
          ganglia_report.host = host
          ganglia_report.size = "xlarge"
        end
      end
    end
  end
end
