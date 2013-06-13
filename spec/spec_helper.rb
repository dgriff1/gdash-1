require 'rubygems'
require 'bundler'

Bundler.require :default, :test

require 'capybara/rspec'
require 'turnip/capybara'

$:.unshift "lib"
require 'gdash'

class TestWidget < GDash::Widget
  attr :foo
  attr :bar
end

def app
  GDash::App
end

Capybara.app = GDash::App

RSpec.configure do |config|
  config.after do
    GDash::Base.instance_variable_set :@instances, nil

    GDash::Base.descendants.each do |base|
      base.instance_variable_set :@instances, nil
    end
  end
end