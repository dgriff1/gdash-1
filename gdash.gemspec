# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gdash/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["R.I.Pienaar", "Jonathan Bryant"]
  gem.email         = ["rip@devco.net", "watersofmemory@gmail.com"]
  gem.description   = %q{A simple dashboard for creating and displaying graphs from multiple monitoring services.}
  gem.summary       = %q{Dashboards}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec}/*`.split("\n")
  gem.name          = "gdash"
  gem.require_paths = ["lib"]
  gem.version       = GDash::VERSION
  
  gem.add_dependency "thin"
  gem.add_dependency "json"
  gem.add_dependency "haml"
  gem.add_dependency "sinatra"
  gem.add_dependency "i18n"
  gem.add_dependency "activesupport"
  gem.add_dependency "redcarpet"
  gem.add_dependency "builder"
  gem.add_dependency "thor"
end
