$:.unshift File.expand_path(File.dirname(__FILE__))

require 'data_centers'

require 'dashboard_helper'
GDash::Widget.send :include, DashboardHelper

require 'boulder'
require 'loadtest'
require 'prod'
require 'zuul'
