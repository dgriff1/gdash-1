require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

spec = eval(File.read('gdash.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

RSpec::Core::RakeTask.new :spec do |spec|
end

desc "Deploy to production with Capistrano"
task :deploy => [:spec] do
  sh "bundle exec cap deploy"
end

desc "Run a local instance on port 3000"
task :run => [:spec] do
  sh "bundle exec thin --address 0.0.0.0 --port 3000 --rackup #{File.expand_path(File.join(File.dirname(__FILE__), "config.ru"))} start"
end