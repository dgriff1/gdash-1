# Getting Started

## Creating Your First Dashboard

Create a file in `dashboards/` containing:

    GDash::Dashboard.define :my_dashboard do |dashboard|
      dashboard.title = "My Dashboard"
      dashboard.description = "My first GDash dashboard"
      dashboard.ganglia_host = "http://bld-mon-03/ganglia"

      dashboard.section :title => "Example Section" do |section|
        section.ganglia_graph :title => "Example Graph" do |graph|
          graph.hosts = "bld-zookeeper-0[123]"
          graph.metrics = "load_one"
        end
      end
    end

Congratulations!  You've created your first GDash dashboard.  You should now see the "My Dashboard" dashboard in both
the list of dashboards on the home page and on the left-hand navigation when viewing dashboards.  Let's break down the
dashboard for some more detail.

## Defining the Dashboard

The first line:

    GDash::Dashboard.define :my_dashboard do |dashboard|

creates the dashboard and gives it a name, in this case `:my_dashboard`.  This name is what shows up in the URL, so you
can directly link to this dashboard at `/my_dashboard`.

Next we define a few details about the dashboard.

    dashboard.title = "My Dashboard"
    dashboard.description = "My first GDash dashboard"

The title is the name of the dashboard which displayed in the interface.  The description is displayed when viewing the
dashboard and is there to give more detail as to what the dashboard is for.

    dashboard.ganglia_host = "http://bld-mon-03/ganglia"

The Ganglia host is the instance of Ganglia this dashboard should point to.  This is inherited by all of the blocks
within the dashboard, and each block can override this locally by setting it within the block.

## Sections

Sections partition graphs into logical groups.

    dashboard.section :title => "Example Section" do |section|

This line creates a section, gives it a title, and adds it to "My Dashboard".  Each section displays its title as its
header and displays all of the nested graphs beneath that header.  The sections within a dashboard are displayed in the
order they are defined.

## Graphs

Graphs can be added to sections (or directly to dashboards).

    section.ganglia_graph :title => "Example Graph" do |graph|
      graph.hosts = "bld-zookeeper-0[123]"
      graph.metrics = "load_one"
    end

This defines a graph that should be pulled from Ganglia, gives it a title, and adds it to "Example Section".  Graphs are
displayed in the order they are defined.  More details on defining the graph can be found in the Ganglia section of the
docs.

## That's It!

That's all there really is to creating GDash graphs.  Take a look at the DSL documentation for the ins and outs of the
DSL itself, or look at the Ganglia and Cacti sections for specifics about how to define graphs.