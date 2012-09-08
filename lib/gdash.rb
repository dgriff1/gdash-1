require 'rubygems'
require 'bundler'

Bundler.require :default

require 'gdash/widget'
require 'gdash/ganglia'
require 'gdash/graph'
require 'gdash/report'
require 'gdash/dashboard'
require 'gdash/section'
require 'gdash/helper'
require 'gdash/app'

Dir[File.expand_path(File.join(File.dirname(__FILE__), %w{.. dashboards ** *}))].each do |file|
  load file
end