GDash::Window.define :one_hour do |window|
  window.title = "Hour"
  window.length = 1.hour
  window.default = true
  window.ganglia_params = { :r => "hour" }
end

GDash::Window.define :two_hours do |window|
  window.length = 2.hours
  window.title = "2 Hours"
  window.ganglia_params = { :r => "2hr" }
end

GDash::Window.define :four_hours do |window|
  window.title = "4 Hours"
  window.length = 4.hours
  window.ganglia_params = { :r => "4hr" }
end

GDash::Window.define :twelve_hours do |window|
  window.title = "12 Hours"
  window.length = 12.hours
  window.ganglia_params = { :r => "12hr" }
end

GDash::Window.define :one_day do |window|
  window.title = "Day"
  window.length = 1.day
  window.ganglia_params = { :r => "day" }
end

GDash::Window.define :two_days do |window|
  window.title = "2 Days"
  window.length = 2.days
  window.ganglia_params = { :r => "2days" }
end

GDash::Window.define :one_week do |window|
  window.title = "1 Week"
  window.length = 1.week
  window.ganglia_params = { :r => "week" }
end

GDash::Window.define :two_weeks do |window|
  window.title = "2 Weeks"
  window.length = 2.weeks
  window.ganglia_params = { :r => "2weeks" }
end

GDash::Window.define :one_month do |window|
  window.title = "Month"
  window.length = 1.month
  window.ganglia_params = { :r => "month" }
end

GDash::Window.define :one_year do |window|
  window.title = "Year"
  window.length = 1.year
  window.ganglia_params = { :r => "year" }
end
