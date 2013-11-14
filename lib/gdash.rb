require "rubygems"

require "open-uri"
require "sinatra"
require "thin"
require "haml"
require "json"
require "i18n"
require "active_support/core_ext"
require "redcarpet"
require "thor"
require "builder"
require "nokogiri"
require "rest-client"
require "uuid"
require "thread"
require "thread/pool"
require "fileutils"
require "tmpdir"
require "stringio"
require "zlib"
require "archive/tar/minitar"

require "gdash/version"
require "gdash/configuration"

require "gdash/data/point"
require "gdash/data/source"
require "gdash/data/sources/ganglia"
require "gdash/data/sources/cacti"
require "gdash/data/set"

require 'gdash/scope'
require 'gdash/base'
require 'gdash/named'
require 'gdash/window'
require 'gdash/windows'
require 'gdash/data_center'
require 'gdash/widget'
require 'gdash/section'
require 'gdash/page'
require 'gdash/dashboard'
require 'gdash/tab'
require 'gdash/tab_set'
require 'gdash/view'
require 'gdash/snapshot'
require 'gdash/nagios'
require 'gdash/helper'
require 'gdash/app'

require "gdash/cli"

module GDash
  class << self
    def config *args
      @config ||= Configuration.new(*args)
      yield config if block_given?
      @config
    end

    def init! options = {}
      dashfile = options[:dashfile] || File.expand_path("Dashfile", FileUtils.pwd)
      load dashfile
      load config.dashboards
    end
  end
end
# need to load config before we load the doc module
require 'gdash/doc'
