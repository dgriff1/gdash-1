# DSL

The GDash DSL is based around the Widgets.  Each dashboard is a tree of widgets which knows how to integrate itself into
the interface automatically.

## Widgets

All widgets take a hash of properties and yield themselves to the block.  If a widget `Foo` has a property `bar`, then
it can be set:

    # Like this
    GDash::Foo.new :bar => :baz

    # Or like this
    GDash::Foo.new do |foo|
      foo.bar = :baz
    end

All widgets can be constructed using the `new` syntax, or they can be added as a child to another node by calling the
widget's underscore name on the parent.

    # This adds a Foo as a child to `some_parent_widget`
    some_parent_widget.foo :bar => :baz

    # And so does this
    some_parent_widget.foo do |foo|
      foo.bar = :baz
    end

A plain widget by itself is not interesting except that it has a set of properties telling GDash where to point for its
graphs.  Those properties are:

- `ganglia_host`
- `cacti_host`
- `nagios_host`
- `nagios_username`
- `nagios_password`

These properties are inherited by nested blocks and can be overridden locally within a block:

    Dashboard.define :foo do |dashboard|
      dashboard.ganglia_host = "http://some-host"

      dashboard.section do |section|
        section.ganglia_graph do |graph|
          # Pulls the graph from http://some-host/graph.php?...
        end
      end

      dashboard.section do |section|
        section.ganglia_host = "http://some-other-host"

        section.ganglia_graph do |graph|
          # Pulls the graph from http://some-other-host/graph.php?...
        end
      end

      dashboard.section do |section|
        section.ganglia_graph do |graph|
          # Pulls the graph from http://some-host/graph.php?...
        end
      end
    end

The first and third graphs will pull from `http://some-host` for their graphs, but the second graph will pull from
`http://some-other-host`.

## Dashboards

Dashboards are the top-level widget, created with `GDash::Dashboard.define`.

They require a name when they are defined.  That name is used to construct URLs for the dashboard and should be a unique
Ruby symbol.

    GDash::Dashboard.define :foo do |dashboard|
      # ...
    end

Dashboards can also have descriptive data.  They can give a `title` and a `description` which are used in the interface
when displaying the dashboard and in navigation boxes.

Dashboards can also be defined nested under other dashboards.  The nested dashboards will not be displayed in-line with
the parent dashboard, but will appear as links nested under the parent dashboard in the left-hand navigation bar.

    GDash::Dashboard.define :foo do |parent|
      parent.dashboard :nested_dashboard do |child|
        # ...
      end
    end

## Sections

Sections divide a dashbaord into logical groupings.  Each section is a grid of child widgets, usually graphs.  The width
of the grid can be set using the `width` property.

    dashboard.section :title => "Some Section", :width => 4 do |section|
      # ...
    end

The title is displayed as the header for the section.

## Graphs

To be written.  See the Ganglia and Cacti pages for more details.

## Custom Widgets

A custom widget can be created by subclassing `GDash::Widget` and overriding the `to_html` method.

    # A custom widget
    class Frob < GDash::Widget
      # Generates the HTML for the widget.  `html` will be passed in if `to_html` is called by the widget's parent.
      def to_html html = nil
        html ||= Builder::XmlMarkup.new

        # Build the HTML
        html.foo do
          # ...
        end
      end
    end

This widget will automatically be available in the DSL with the `frob` method just like any other widget.

All widgets automatically have `children` and a `parent` defined (although not neccessarily populated in the
constructor.)  If the constructor is overridden, be sure to pass the rest arguments and the block to super:

    def initialize my_required_arg, *args, &block
      @required_arg = my_required_arg
      super *args, &block
    end