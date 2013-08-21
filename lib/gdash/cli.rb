module GDash
  class Cli < Thor
    include Thor::Actions

    desc "new PATH", "Generates a new GDash in PATH"
    def new path
      self.source_paths << File.expand_path("templates", File.dirname(__FILE__))
      self.destination_root = path

      FileUtils.mkdir_p path

      template "Dashfile"
      template "dashboards.rb"
      template "config.ru"
    end

    desc "server", "Starts a local server for testing"
    method_options :address => :string, :port => :integer, :config => :string
    def server
      address = options[:address] || "0.0.0.0"
      port = options[:port] || 3000
      config = options[:config] || File.expand_path("Dashfile", FileUtils.pwd)

      load config
      load GDash.config.dashboards

      Thin::Server.start address, port, GDash::App
    end

    desc "snapshot TARBALL", "Starts a local server for viewing a snapshot"
    method_options :address => :string, :port => :integer, :config => :string
    def snapshot tarball
      address = options[:address] || "0.0.0.0"
      port = options[:port] || 3000

      GDash::Snapshot::Server.run address, port, tarball
    end
  end
end
