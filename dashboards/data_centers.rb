GDash::DataCenter.define :boulder do |boulder|
  boulder.prefix = "bld"
  boulder.ganglia_host = "http://bld-mon-03/ganglia"
  boulder.nagios_host = "http://bld-nagios-01/nagios"
  boulder.nagios_username = "gdash"
  boulder.nagios_password = "gdash"
end

GDash::DataCenter.define :denver do |denver|
  denver.prefix = "qd"
  denver.ganglia_host = "http://bld-mon-03/ganglia-qd"
  denver.nagios_host = "http://bld-mon-03/nagios-qd"
  denver.nagios_username = "gdash"
  denver.nagios_password = "gdash"
end

GDash::DataCenter.define :seattle do |seattle|
  seattle.prefix = "qs"
  seattle.ganglia_host = "http://bld-mon-03/ganglia-qs"
  seattle.nagios_host = "http://bld-mon-03/nagios-qd"
  seattle.nagios_username = "gdash"
  seattle.nagios_password = "gdash"
end
