GDash::DataCenter.define :boulder do |boulder|
  boulder.prefix = "bld"
  boulder.ganglia_host = "http://bld-mon-03.f4tech.com/ganglia"
  boulder.cacti_host = "http://bld-cacti-01.f4tech.com/cacti"
  boulder.nagios_host = "http://bld-nagios-01.f4tech.com/nagios"
  boulder.nagios_username = "gdash"
  boulder.nagios_password = "gdash"
end

GDash::DataCenter.define :denver do |denver|
  denver.prefix = "qd"
  denver.ganglia_host = "http://bld-mon-03.f4tech.com/ganglia-qd"
  denver.cacti_host = "http://bld-mon-03.f4tech.com/cacti-qd"
  denver.nagios_host = "http://bld-mon-03.f4tech.com/nagios-qd"
  denver.nagios_username = "gdash"
  denver.nagios_password = "gdash"
end

GDash::DataCenter.define :seattle do |seattle|
  seattle.prefix = "qs"
  seattle.ganglia_host = "http://bld-mon-03.f4tech.com/ganglia-qs"
  seattle.cacti_host = "http://bld-mon-03.f4tech.com/cacti-qs"
  seattle.nagios_host = "http://bld-mon-03.f4tech.com/nagios-qs"
  seattle.nagios_username = "gdash"
  seattle.nagios_password = "gdash"
end
