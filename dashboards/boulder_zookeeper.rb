GDash::Dashboard.new :boulder_zookeeper do |dashboard|
  dashboard.title = "Boulder ZooKeeper"
  dashboard.description = "Local ZooKeeper cluster in Boulder"

  dashboard.section :title => "Cluster Metrics", :width => 2 do |section|
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
    dashboard.section :title => "Host: #{host}", :width => 3 do |section|
    end
  end
end
