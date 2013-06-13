GDash.window :one_hour do
  title "Hour"
  length 1.hour
  default true
  ganglia_params({ :r => "hour" })
end

GDash.window :two_hours do
  length 2.hours
  title "2 Hours"
  ganglia_params({ :r => "2hr" })
end

GDash.window :four_hours do
  title "4 Hours"
  length 4.hours
  ganglia_params({ :r => "4hr" })
end

GDash.window :twelve_hours do
  title "12 Hours"
  length 12.hours
  ganglia_params({ :r => "12hr" })
end

GDash.window :one_day do
  title "Day"
  length 1.day
  ganglia_params({ :r => "day" })
end

GDash.window :two_days do
  title "2 Days"
  length 2.days
  ganglia_params({ :r => "2days" })
end

GDash.window :one_week do
  title "1 Week"
  length 1.week
  ganglia_params({ :r => "week" })
end

GDash.window :two_weeks do
  title "2 Weeks"
  length 2.weeks
  ganglia_params({ :r => "2weeks" })
end

GDash.window :one_month do
  title "Month"
  length 1.month
  ganglia_params({ :r => "month" })
end

GDash.window :one_year do
  title "Year"
  length 1.year
  ganglia_params({ :r => "year" })
end
