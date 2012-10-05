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