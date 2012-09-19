GDash::Dashboard.define :boulder_zookeeper do |dashboard|
  dashboard.title = "Boulder ZooKeeper"
  dashboard.description = "Local ZooKeeper cluster in Boulder"
  dashboard.ganglia_host = "http://bld-mon-03/ganglia"

  dashboard.section :title => "System", :width => 2 do |section|
    section.ganglia_report :title => "CPU Usage" do |ganglia_report|
      ganglia_report.report = "cpu_report"
      ganglia_report.cluster = "Boulder Zookeeper"
      ganglia_report.size = "xlarge"
    end

    section.ganglia_report :title => "Network Usage" do |ganglia_report|
      ganglia_report.report = "network_report"
      ganglia_report.cluster = "Boulder Zookeeper"
      ganglia_report.size = "xlarge"
    end
  end

  dashboard.section :title => "Cluster", :width => 2 do |section|
    section.ganglia_graph :title => "Heap Used" do |report|
      report.hosts = "bld-zookeeper-0[123]"
      report.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
      report.size = "xlarge"
    end

    section.ganglia_graph :title => "Disk Writes" do |ganglia_graph|
      ganglia_graph.hosts = "bld-zookeeper-0[123]"
      ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
      ganglia_graph.size = "xlarge"
    end

    section.ganglia_graph :title => "Outstanding Requests" do |ganglia_graph|
      ganglia_graph.hosts = "bld-zookeeper-0[123]"
      ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.OutstandingRequests"
      ganglia_graph.size = "xlarge"
    end

    section.ganglia_graph :title => "Latency" do |ganglia_graph|
      ganglia_graph.hosts = "bld-zookeeper-0[123]"
      ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.LastLatency"
      ganglia_graph.size = "xlarge"
    end
  end

  ["bld-zookeeper-01", "bld-zookeeper-02", "bld-zookeeper-03"].each do |host|
    dashboard.section :title => "Host: #{host}", :width => 4 do |section|
      section.ganglia_report do |graph|
        graph.report = "zk_connection_throughput_report"
        graph.cluster = "Boulder Zookeeper"
        graph.host = "#{host}.f4tech.com"
        graph.size = "xlarge"
      end

      section.ganglia_report do |ganglia_report|
        ganglia_report.report = "zk_connection_latency_report"
        ganglia_report.cluster = "Boulder Zookeeper"
        ganglia_report.host = "#{host}.f4tech.com"
        ganglia_report.size = "xlarge"
      end

      section.ganglia_report do |ganglia_report|
        ganglia_report.report = "zk_leader_follower_latency_report"
        ganglia_report.cluster = "Boulder Zookeeper"
        ganglia_report.host = "#{host}.f4tech.com"
        ganglia_report.size = "xlarge"
      end
    end
  end
end
