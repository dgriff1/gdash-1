GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.dashboard :hadoop do |hadoop|
    hadoop.dashboard :boulder_zookeeper do |dashboard|
      dashboard.title = "ZooKeeper"
      dashboard.description = "ZooKeeper cluster"

      dashboard.section :title => "Nagios", :width => 1 do |nagios|
        nagios.nagios "zookeeper-servers"
      end

      dashboard.system_section "Boulder Zookeeper", "boulder_zookeeper"

      dashboard.section :title => "Cluster", :width => 2 do |section|
        section.ganglia_graph :boulder_zookeeper_heap_used, :title => "Heap Used" do |report|
          report.hosts = "bld-zookeeper-0[123]"
          report.metrics = "sun.management.MemoryImpl.Memory.HeapMemoryUsage.used"
          report.size = "xlarge"
        end

        section.ganglia_graph :boulder_zookeeper_disk_writes, :title => "Disk Writes" do |ganglia_graph|
          ganglia_graph.hosts = "bld-zookeeper-0[123]"
          ganglia_graph.metrics = "diskstat_sda_write_bytes_per_sec"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :boulder_zookeeper_outstanding_requests, :title => "Outstanding Requests" do |ganglia_graph|
          ganglia_graph.hosts = "bld-zookeeper-0[123]"
          ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.OutstandingRequests"
          ganglia_graph.size = "xlarge"
        end

        section.ganglia_graph :boulder_zookeeper_latency, :title => "Latency" do |ganglia_graph|
          ganglia_graph.hosts = "bld-zookeeper-0[123]"
          ganglia_graph.metrics = "org.apache.zookeeper.server.ConnectionBean.LastLatency"
          ganglia_graph.size = "xlarge"
        end
      end

      ["bld-zookeeper-01", "bld-zookeeper-02", "bld-zookeeper-03"].each do |host|
        dashboard.section :title => "Host: #{host}", :width => 4 do |section|
          section.ganglia_report :"boulder_zookeeper_#{host}_throughput" do |graph|
            graph.report = "zk_connection_throughput_report"
            graph.cluster = "Boulder Zookeeper"
            graph.host = "#{host}.f4tech.com"
            graph.size = "xlarge"
          end

          section.ganglia_report :"boulder_zookeeper_#{host}_connection_latency" do |ganglia_report|
            ganglia_report.report = "zk_connection_latency_report"
            ganglia_report.cluster = "Boulder Zookeeper"
            ganglia_report.host = "#{host}.f4tech.com"
            ganglia_report.size = "xlarge"
          end

          section.ganglia_report :"boulder_zookeeper_#{host}_leader_follower_latency" do |ganglia_report|
            ganglia_report.report = "zk_leader_follower_latency_report"
            ganglia_report.cluster = "Boulder Zookeeper"
            ganglia_report.host = "#{host}.f4tech.com"
            ganglia_report.size = "xlarge"
          end
        end
      end
    end
  end
end