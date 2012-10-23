require 'boulder/rust'
require 'boulder/hadoop'

GDash::Dashboard.toplevel :boulder do |boulder|
  boulder.title = "Boulder"
  boulder.description = "Servers in Boulder"
  boulder.data_center = :boulder
end
