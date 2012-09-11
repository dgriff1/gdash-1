set :application, "GDash"
set :repository,  "ssh://almbuild@git.f4tech.com/export/git/gdash.git"
set :deploy_to, "/home/gdash"
set :use_sudo, false
set :branch, "master"
set :user, "gdash"

set :rvm_path, "/home/$USER/.rvm"
set :rvm_bin_path, "#{rvm_path}/bin"
set :rvm_lib_path, "#{rvm_path}/lib"

set :scm, :git

role :web, "bld-rust-02"
role :app, "bld-rust-02"
role :db,  "bld-rust-02", :primary => true

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
  #run "cd #{release_path} && bundle install"
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