GDash::Dashboard.define :example do |dashboard|
  dashboard.title = "Cacti Example"
  dashboard.description = "Example of using a graph from Cacti"
  dashboard.cacti_host = "https://qs-mon-01.rallydev.com/cacti"

  dashboard.section :title => "Cacti Graphs" do |section|
    section.cacti_graph do |cacti_graph|
      cacti_graph.graph_id = 810
      cacti_graph.rra_id = 5
    end
  end

  dashboard.section :title => "Test Section", :width => 2 do |section|
    section.section :title => "Foo", :width => 4 do |foo_section|
      8.times do
        foo_section.cacti_graph do |cacti_graph|
          cacti_graph.graph_id = 810
          cacti_graph.rra_id = 5
        end
      end
    end

    section.section :title => "Bar", :width => 4 do |bar_section|
      8.times do
        bar_section.cacti_graph do |cacti_graph|
          cacti_graph.graph_id = 810
          cacti_graph.rra_id = 5
        end
      end
    end

    section.section :title => "Baz", :width => 4 do |baz_section|
      8.times do
        baz_section.cacti_graph do |cacti_graph|
          cacti_graph.graph_id = 810
          cacti_graph.rra_id = 5
        end
      end
    end

    section.section :title => "Quux", :width => 4 do |quux_section|
      8.times do
        quux_section.cacti_graph do |cacti_graph|
          cacti_graph.graph_id = 810
          cacti_graph.rra_id = 5
        end
      end
    end
  end
end