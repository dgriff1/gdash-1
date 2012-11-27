# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :cli => "--color --format Fuubar", :turnip => true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.haml$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Turnip features and steps
  watch(%r{^spec/features/(.+)\.feature$})
  watch(%r{^spec/features/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/features' }
end

guard 'coffeescript', :input => 'lib/gdash/coffeescript',  :output => 'lib/gdash/public/js'
guard 'coffeescript', :input => 'spec/gdash/coffeescript', :output => 'spec/gdash/javascript'

guard :jasmine, :server => :thin, :rackup_config => File.expand_path("jasmine.ru", File.dirname(__FILE__)), :server_env => :development, :console => :always, :spec_dir => File.expand_path("spec/gdash/javascripts", File.dirname(__FILE__)) do
  watch(%r{lib/gdash/coffeescript/spec\.coffee$}) { 'lib/gdash/public/js' }
  watch(%r{spec/gdash/javascript/.+_spec\.js})
  watch(%r{lib/gdash/public/js/(.+?)\.js(?:\.\w+)*$}) { |m| "spec/gdash/javascript/#{ m[1] }_spec.js" }
end
