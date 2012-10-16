# Ganglia Integration

There are two ways of rendering graphs from Ganglia: Graphs and Reports.

    GDash::Dashboard.define :my_dashboard do |dashboard|
      dashboard.section :title => "First Section" do |section|
        section.ganglia_graph :title => "A Ganglia Graph" do |graph|
          graph.hosts = "some-host-names-\d"
          graph.metrics = "load_one"
        end
        section.ganglia_report :title => "A Ganglia Report" do |report|
          report.report = "some_report_in_ganglia"
          report.cluster = "Cluster Name"
          report.host = "some-host-name"
        end
      end
    end

## Common

There is a top-level option available on each widget to set the Ganglia host, named `ganglia_host`.

There are two options common to both Graphs and Reports:

- `title`: The title displayed at the top of the graph
- `size`: The size of the graph.  Must be one of:
  - `small`
  - `medium`
  - `large`
  - `xlarge`
  - `xxlarge`

Custom attributes can be added to the URL parameters of a graph or report by using the `custom` method:

    section.ganglia_graph :title => "Some Special Graph" do |graph|
      graph.custom :foo => :bar, :baz => :quux
    end

## Graphs

Graphs are simple graphs which are dynamically built based on two main parameters:

- `hosts`: A regular expression for host names to include in the graph
- `metrics`: A regular expression for metric names to include in the graph

These two parameters alone are enough to define the graph, and usually are sufficient.

    section.ganglia_graph :title => "A Simple Graph" do |graph|
      graph.hosts = "some-host-\d+"
      graph.metrics = "load_.*"
    end

The rest of the parameters allow more fine-grained control of how the graph appears:

- `vertical_label`: The label to display on the Y-Axis of the graph
- `upper_limit` and `lower_limit`: Put hard bounds on the Y-Axis of the graph.  Both can be set at the same time by
calling `limits=` with a range.
- `legend`: Whether or not to display the legend at the bottom of the graph
- `type`: Either `line` for a line graph or `stack` for a stacked bar graph

A more complete example would look like:

    section.ganglia_graph :title => "A More Complete Example" do |graph|
      graph.hosts = "some-host-\d+"
      graph.metrics = "load_.*"
      graph.vertical_label = "Processes in queue"
      graph.range = (5..50)
      graph.legend = false
      graph.type = :line
    end

## Reports

Reports are defined in PHP on the Ganglia server.  They allow very precise control over the display of metrics and are
usually used to display metrics about an entire cluster.  There are two or three parameters required to get a report:

- `report`: The name of the report in Ganglia
- `cluster`: The cluster to apply the report to
- `host`: The host within the cluster to apply the report to.  This may or may not be required, depending on the report.

As an example, the CPU Usage report doesn't require a specific host:

    section.ganglia_report :title => "CPU Usage" do |report|
      report.report = "cpu_usage"
      report.cluster = "Some Cluster"
    end

But another report might:

    section.ganglia_report :title => "My Custom Report" do |report|
      report.report = "custom_report_name_in_ganglia"
      report.cluster = "Some Cluster"
      report.host = "some-host"
    end
