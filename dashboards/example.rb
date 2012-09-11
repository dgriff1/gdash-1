GDash::Dashboard.define :example do |dashboard|
  dashboard.title = "Cacti Example"
  dashboard.description = "Example of using a graph from Cacti"
  dashboard.cacti_host = "https://qs-mon-01.rallydev.com/cacti"

  dashboard.section :title => "Cacti Graphs" do |section|
    section.cacti_graph do |cacti_graph|
      cacti_graph.graph_id = 810
      cacti_graph.rrd_id = 5
    end
  end
end