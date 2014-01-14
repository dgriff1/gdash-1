# Nagios Integration

There are three top-level options available on each widget to configure the Nagios host:

- `nagios_host`
- `nagios_username`
- `nagios_password`

A simple list of the state of Nagios checks can be added with the `nagios` method.  It takes the host group as a
required argument.

Example:

    section.nagios "nagios-group" do |nagios|
      # Move along, nothing to see here...
    end
