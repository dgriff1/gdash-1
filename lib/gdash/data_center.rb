module GDash
  class DataCenter < Named
    attr :prefix, :ganglia_host, :graphite_host, :cacti_host, :nagios_host, :nagios_username, :nagios_password
  end
end