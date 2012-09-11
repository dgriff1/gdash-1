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
  run "bundle exec cap deploy"
end
