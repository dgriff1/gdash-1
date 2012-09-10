GDash::Dashboard.new :boulder_zookeeper do |dashboard|
  dashboard.title = "Boulder ZooKeeper"
  dashboard.description = "Local ZooKeeper cluster in Boulder"
  dashboard.ganglia_host = "http://bld-mon-03/ganglia"

  dashboard.section :title => "System", :width => 2 do |section|
    section.report :title => "CPU Usage" do |report|
      report.report = "cpu_report"
      report.cluster = "Boulder Zookeeper"
    end

    section.report :title => "Network Usage" do |report|
      report.report = "network_report"
      report.cluster = "Boulder Zookeeper"
    end
  end

  dashboard.section :title => "Cluster", :width => 2 do |section|
    section.graph :title => "Heap Used" do |graph|
      graph.hosts = "bld-zookeeper-0[123]"
      graph.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
    end

    section.graph :title => "Disk Writes" do |graph|
      graph.hosts = "bld-zookeeper-0[123]"
      graph.metrics = "diskstat_sda_write_bytes_per_sec"
    end

    section.graph :title => "Outstanding Requests" do |graph|
      graph.hosts = "bld-zookeeper-0[123]"
      graph.metrics = "org.apache.zookeeper.server.ConnectionBean.OutstandingRequests"
    end

    section.graph :title => "Latency" do |graph|
      graph.hosts = "bld-zookeeper-0[123]"
      graph.metrics = "org.apache.zookeeper.server.ConnectionBean.LastLatency"
    end
  end

  ["bld-zookeeper-01", "bld-zookeeper-02", "bld-zookeeper-03"].each do |host|
    dashboard.section :title => "Host: #{host}", :width => 4 do |section|
      section.report do |report|
        report.report = "zk_connection_throughput_report"
        report.cluster = "Boulder Zookeeper"
        report.host = "#{host}.f4tech.com"
      end

      section.report do |report|
        report.report = "zk_connection_latency_report"
        report.cluster = "Boulder Zookeeper"
        report.host = "#{host}.f4tech.com"
      end

      section.report do |report|
        report.report = "zk_leader_follower_latency_report"
        report.cluster = "Boulder Zookeeper"
        report.host = "#{host}.f4tech.com"
      end
    end
  end
end
