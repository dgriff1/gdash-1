module DashboardHelper
  def system_section cluster_name, prefix, options = {}
    options[:title] ||= "System"
    options[:width] ||= 4

    section options do |section|
      section.ganglia_report :"#{prefix}_load_average", :title => "Load Average" do |ganglia_report|
        ganglia_report.report = "load_report"
        ganglia_report.cluster = cluster_name
        ganglia_report.size = "large"
      end

      section.ganglia_report :"#{prefix}_cpu_report", :title => "CPU Usage" do |ganglia_report|
        ganglia_report.report = "cpu_report"
        ganglia_report.cluster = cluster_name
        ganglia_report.size = "large"
      end

      section.ganglia_report :"#{prefix}_network_report", :title => "Network Usage" do |ganglia_report|
        ganglia_report.report = "network_report"
        ganglia_report.cluster = cluster_name
        ganglia_report.size = "large"
      end

      section.ganglia_report :"#{prefix}_mem_report", :title => "Memory Usage" do |ganglia_report|
        ganglia_report.report = "mem_report"
        ganglia_report.cluster = cluster_name
        ganglia_report.size = "large"
      end
    end
  end

  def table *args
    options = args.extract_options!
    section options do |section|
      args.each do |arg|
        yield section, arg if block_given?
      end
    end
  end
end