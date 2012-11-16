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

guard 'coffeescript', :input => 'lib/gdash',  :output => 'lib/gdash/public/js'
guard 'coffeescript', :input => 'spec/gdash', :output => 'spec/gdash'

guard :jasmine, :rackup_config => "jasmine.ru", :server_env => :development, :console => :always do
  watch(%r{spec/gdash/spec\.(js\.coffee|js|coffee)$}) { 'spec/gdash' }
  watch(%r{spec/gdash/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{lib/gdash/public/js/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/gdash/#{ m[1] }_spec.#{ m[2] }" }
end
