GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.dashboard :hadoop do |hadoop|
    hadoop.dashboard :boulder_hadoop do |dashboard|
      dashboard.title = "Hadoop"
      dashboard.description = "Hadoop Cluster"

      dashboard.system_section "Hadoop Cluster", "boulder_hadoop"
    end
  end
end