{ 
  :qd => {
    :title => "Denver",
    :prefix => "qd",
  }, 
  :qs => {
    :title => "Seattle",
    :prefix => "qs"
  } 

}.each do |name, site|
  GDash::Dashboard.define :"#{name}" do |dashboard|
    dashboard.title = site[:title]
    dashboard.description = "#{site[:title]} Hosts & Services"
    dashboard.ganglia_host = "http://bld-mon-03.f4tech.com/ganglia-#{site[:prefix]}"

    dashboard.ganglia_report :title => "ALM Request Rate" do |ganglia_report|
      ganglia_report.report = "slm_request_rate_report"
      ganglia_report.cluster = "ALM"
      ganglia_report.size = "xlarge"
    end

    dashboard.ganglia_report :title => "ALM Response Time" do |ganglia_report|
      ganglia_report.report = "slm_response_time_report"
      ganglia_report.cluster = "ALM"
      ganglia_report.size = "xlarge"
    end

    dashboard.dashboard :"#{site[:prefix]}_alm" do |alm_dash|
      alm_dash.title = "ALM App Servers"
        [
          "#{site[:prefix]}-app-01.rally.prod", 
          "#{site[:prefix]}-app-02.rally.prod", 
          "#{site[:prefix]}-app-03.rally.prod", 
          "#{site[:prefix]}-app-04.rally.prod", 
          "#{site[:prefix]}-app-05.rally.prod"
        ].each do |host|
        alm_dash.section :title => "#{host}", :width => 2 do |section|
          section.ganglia_report :title => "Request Rate" do |ganglia_report|
            ganglia_report.report = "slm_request_rate_report"
            ganglia_report.cluster = "ALM"
            ganglia_report.host = host
            ganglia_report.size = "xlarge"
          end

          section.ganglia_report :title => "Response Time" do |ganglia_report|
            ganglia_report.report = "slm_response_time_report"
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
end
