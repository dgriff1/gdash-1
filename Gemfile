source 'http://rubygems.org'

gem "rake"
gem 'sinatra'
gem "i18n"
gem "activesupport", :require => "active_support/core_ext"
gem 'redcarpet'
gem "builder"
gem "haml"
gem "json"

group :development do
  gem "guard-rspec"
  gem 'rb-fsevent', '~> 0.9.1'
  gem "fuubar"
end

group :test do
  gem "rspec"
  gem "rack-test", :require => "rack/test"
  gem "turnip"
  gem "capybara"
end

group :production do
  gem "thin"
  gem "capistrano"
  gem "god"
end

