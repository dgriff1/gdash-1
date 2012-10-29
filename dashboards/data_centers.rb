GDash::DataCenter.define :boulder do |boulder|
  boulder.prefix = "bld"
  boulder.ganglia_host = "http://bld-mon-03/ganglia"
  boulder.cacti_host = "http://bld-cacti-01/cacti"
  boulder.nagios_host = "http://bld-nagios-01/nagios"
  boulder.nagios_username = "bcotton"
  boulder.nagios_password = "just4nagios"
end

GDash::DataCenter.define :denver do |denver|
  denver.prefix = "qd"
  denver.ganglia_host = "http://bld-mon-03/ganglia-qd"
  denver.cacti_host = "http://bld-mon-03/cacti-qd"
  denver.nagios_host = "http://bld-mon-03/nagios-qd"
  denver.nagios_username = "gdash"
  denver.nagios_password = "gdash"
end

GDash::DataCenter.define :seattle do |seattle|
  seattle.prefix = "qs"
  seattle.ganglia_host = "http://bld-mon-03/ganglia-qs"
  seattle.cacti_host = "http://bld-mon-03/cacti-qs"
  seattle.nagios_host = "http://bld-mon-03/nagios-qd"
  seattle.nagios_username = "gdash"
  seattle.nagios_password = "gdash"
end
