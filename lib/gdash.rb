require 'rubygems'
require 'bundler'

Bundler.require :default

require 'gdash/window'
require 'gdash/widget'
require 'gdash/ganglia'
require 'gdash/ganglia_graph'
require 'gdash/ganglia_report'
require 'gdash/cacti_graph'
require 'gdash/dashboard'
require 'gdash/section'
require 'gdash/helper'
require 'gdash/app'

Dir[File.expand_path(File.join(File.dirname(__FILE__), %w{.. dashboards ** *}))].each do |file|
  load file
end