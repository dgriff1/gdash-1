set :application, "GDash"
set :repository,  "ssh://git/export/git/gdash.git"

set :scm, :gid

role :web, "bld-mon-03"
role :app, "bld-mon-03"
role :db,  "bld-mon-03", :primary => true


#########
# Hooks #
#########

namespace :rvm do
  desc "Tell RVM to trust the project .rvmrc"
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

task :install_bundle do
  run "cd #{release_path} && bundle install"
end

after "deploy:update", "rvm:trust_rvmrc"
after "deploy:update", "deploy:cleanup"

namespace :god do
  task :status do
    run "cd #{fetch(:deploy_to)}/current && bundle exec god status" rescue nil
  end

  task :stop do
    begin
      god.status
      run "cd #{fetch(:deploy_to)}/current && bundle exec god quit" rescue nil
    rescue
      nil
    end
  end

  task :start do
    run "cd #{fetch(:deploy_to)}/current && bundle exec god -c config/god.rb --log #{fetch(:deploy_to)}/shared/log/god.log" rescue nil
    sleep 60
    god.status
  end
end

before "deploy:update", "god:stop"
after "deploy:update", "install_bundle"
after "deploy:update", "god:start"