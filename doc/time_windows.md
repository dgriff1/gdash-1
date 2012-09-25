# Time Windows

Time windows can be defined using the `Window` class.  A basic time window is defined simply:

    GDash::Window.define :my_window do |window|
      window.title = "My Special Window"
      window.length = 1.month + 2.weeks + 3.days + 4.hours + 5.minutes + 6.seconds
    end

Time windows always take a name and an optional hash of parameters as the constructor arguments.  The name is used to
construct URLs and should be a unique Ruby symbol.

Once defined, the window will appear in the interface automatically.  In the interface, windows are sorted by their
length, not their titles or names.

## Custom Windows

Custom, dashboard-specific time windows can be added to a dashboard using the `custom_window` method.

    GDash::Dashboard.define :foo do |dashboard|
      dashboard.custom_window :some_unique_identifier do |custom_window|
        custom_window.title = "My Custom Window"
        custom_window.length = 42.minutes
      end
    end

## Custom Attributes

Windows have generally sane defaults for generating URL parameters.  In special cases, they can be overridden by passing
a hash to the `backend_params` methods.  This hash will replace the default one and be added to the URL as GET
parameters.

    GDash::Window.new :my_window do |window|
      window.title = "My Special Window"
      window.length = 1.month + 2.weeks + 3.days + 4.hours + 5.minutes + 6.seconds
      window.ganglia_params = {
        :r  => "...",
        :cs => "...",
        :ce => "..."
      }
      window.cacti_params = {
        :graph_start => "...",
        :graph_end => "..."
      }
    end
