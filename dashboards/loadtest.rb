LOADTEST_HOSTS = (1..5).map do |n|
  "dsc-loadtestapp-0#{n}.f4tech.com"
end

require 'loadtest/alm'
require 'loadtest/alm_compare'

GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.dashboard :loadtest do |dashboard|
    dashboard.title = "Boulder Loadtest"
    dashboard.description = "LoadTest Hosts & Services"
  end
end