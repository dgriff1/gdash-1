require 'rubygems'
require 'bundler'

Bundler.require :default, :test

require 'capybara/rspec'
require 'turnip/capybara'

$:.unshift "lib"
require 'gdash'

def app
  GDash::App
end

Capybara.app = GDash::App

RSpec.configure do |config|
  config.after do
    GDash::Widget.instance_variable_set :@widgets, nil
  end
end