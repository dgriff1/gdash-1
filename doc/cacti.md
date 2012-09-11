# Cacti Integration

Graphs from Cacti can be used with the `cacti_graph` method.  It takes two required options:

- `graph_id`: ???
- `rra_id`: ???

Example:

    section.cacti_graph :title => "A Cacti Graph" do |graph|
      graph.graph_id = 810
      graph.rra_id = 5
    end
