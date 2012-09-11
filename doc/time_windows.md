# Time Windows

Time windows can be defined using the `Window` class.  A basic time window is defined simply:

    GDash::Window.new :my_window do |window|
      window.title = "My Special Window"
      window.length = 1.month + 2.weeks + 3.days + 4.hours + 5.minutes + 6.seconds
    end

Once defined, the window will appear in the interface automatically.  In the interface, windows are sorted by their
length, not their titles or names.

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
