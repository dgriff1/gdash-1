PROD_SITES.each do |name, site|
  GDash::Dashboard.define name do |dashboard|
    dashboard.dashboard :"#{site[:prefix]}_zookeeper" do |zookeeper|
      zookeeper.title = "ZooKeeper"
      zookeeper.description = "ZooKeeper cluster"

      zookeeper.system_section "Zookeeper", site[:prefix]

      zookeeper.section :title => "Cluster", :width => 2 do |section|
        section.ganglia_graph :"#{site[:prefix]}_zookeeper_heap_used", :title => "Heap Used" do |report|
          report.hosts = "#{site[:prefix]}-zookeeper-0[123]"
          report.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
          report.size = "xlarge"
        end

        section.ganglia_graph :"#{site[:prefix]}_zookeeper_disk_writes", :title => "Disk Writes" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
          ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :"#{site[:prefix]}_zookeeper_outstanding_requests", :title => "Outstanding Requests" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
          ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.OutstandingRequests"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :"#{site[:prefix]}_zookeeper_latency", :title => "Latency" do |ganglia_graph|
          ganglia_graph.hosts = "#{site[:prefix]}-zookeeper-0[123]"
          ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.LastLatency"
          ganglia_graph.size = "xlarge"
        end
      end

      site[:zookeeper_servers].each do |host|
        zookeeper.section :title => "Host: #{host}", :width => 3 do |section|
          section.ganglia_report :"#{site[:prefix]}_#{host}_connection_throughput", :title => "Connection Throughput" do |ganglia_report|
            ganglia_report.report = "zk_connection_throughput_report"
            ganglia_report.cluster = "Zookeeper"
            ganglia_report.host = host
            ganglia_report.size = "xlarge"
          end

          section.ganglia_report :"#{site[:prefix]}_#{host}_connection_latency", :title => "Connection Latency" do |ganglia_report|
            ganglia_report.report = "zk_connection_latency_report"
            ganglia_report.cluster = "Zookeeper"
            ganglia_report.host = host
            ganglia_report.size = "xlarge"
          end

          section.ganglia_report :"#{site[:prefix]}_#{host}_leader_follower_latency", :title => "Leader/Follower Latency" do |ganglia_report|
            ganglia_report.report = "zk_leader_follower_latency_report"
            ganglia_report.cluster = "Zookeeper"
            ganglia_report.host = host
            ganglia_report.size = "xlarge"
          end
        end
      end
    end
  end
end
