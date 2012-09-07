require 'rubygems'
require 'bundler'

Bundler.require :default, :test

$:.unshift "lib"
require 'gdash'

def app
  GDash::App
end