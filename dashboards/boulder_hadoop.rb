GDash::Dashboard.define :boulder_hadoop do |dashboard|
  dashboard.title = "Boulder Hadoop"
  dashboard.description = "Hadoop Cluster in Boulder"
  dashboard.ganglia_host = "http://bld-mon-03/ganglia"

  dashboard.section :title => "System", :width => 2 do |section|
    section.ganglia_report :title => "CPU Usage" do |ganglia_report|
      ganglia_report.report = "cpu_report"
      ganglia_report.cluster = "Boulder Hadoop Revisited"
      ganglia_report.size = "xlarge"
    end

    section.ganglia_report :title => "Network Usage" do |ganglia_report|
      ganglia_report.report = "network_report"
      ganglia_report.cluster = "Boulder Hadoop Revisited"
      ganglia_report.size = "xlarge"
    end
  end
end
