require 'rubygems'
require 'gdash'

load File.expand_path("Dashfile", File.dirname(__FILE__))
load GDash.config.dashboards

run GDash::App