{ "devner" => "qd",
  "seattle"  => "qs"}.each do |datacenter, site|
    GDash::Dashboard.new :"alm_#{datacenter}" do |dashboard|
      dashboard.title = "#{datacenter.camelize} ALM"
      dashboard.ganglia_host = "http://bld-mon-03/ganglia-#{site}"

    ["#{site}-app-01.rally.prod", "#{site}-app-02.rally.prod", "#{site}-app-03.rally.prod", "#{site}-app-04.rally.prod", "#{site}-app-05.rally.prod"].each do |host|
      dashboard.section :title => "#{host}", :width => 2 do |section|
        section.report :title => "Request Rate" do |report|
          report.report = "slm_request_rate_report"
          report.cluster = "ALM"
          report.host = host
          report.size = "xlarge"
        end

        section.report :title => "Response Time" do |report|
          report.report = "slm_response_time_report"
          report.cluster = "ALM"
          report.host = host
          report.size = "xlarge"
        end

        section.report :title => "Network Usage" do |report|
          report.report = "network_report"
          report.cluster = "ALM"
          report.host = host
          report.size = "xlarge"
        end

        section.report :title => "Load" do |report|
          report.report = "load_report"
          report.cluster = "ALM"
          report.host = host
          report.size = "xlarge"
        end
      end
    end
  end
end