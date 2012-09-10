GDash::Window.new :one_hour do |window|
  window.title = "Last Hour"
  window.length = 1.hour
  window.default = true
end

GDash::Window.new :two_hours do |window|
  window.length = 2.hours
  window.title = "Last 2 Hours"
end

GDash::Window.new :four_hours do |window|
  window.title = "Last 4 Hours"
  window.length = 4.hours
end

GDash::Window.new :twelve_hours do |window|
  window.title = "Last 12 Hours"
  window.length = 12.hours
end

GDash::Window.new :one_day do |window|
  window.title = "Last Day"
  window.length = 1.day
end

GDash::Window.new :two_days do |window|
  window.title = "Last 2 Days"
  window.length = 2.days
end

GDash::Window.new :one_week do |window|
  window.title = "Last 1 Week"
  window.length = 1.week
end

GDash::Window.new :two_weeks do |window|
  window.title = "Last 2 Weeks"
  window.length = 2.weeks
end

GDash::Window.new :one_month do |window|
  window.title = "Last Month"
  window.length = 1.month
end

GDash::Window.new :one_year do |window|
  window.title = "Last Year"
  window.length = 1.year
end
