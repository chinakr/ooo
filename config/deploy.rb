#require "bundler/capistrano"

default_run_options[:pty] = true
set :user, 'huatu'
set :domain, 'u.vstudy.cn'
set :application, 'ooo'

set :repository,  "#{user}@#{domain}:/home/www/src/#{application}.git"
set :deploy_to, "/home/www/#{domain}/"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "#{user}@#{domain}"                          # Your HTTP server, Apache/etc
role :app, "#{user}@#{domain}"                          # This may be the same as your `Web` server
role :db, "#{user}@#{domain}", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

#set :deploy_via, :remote_cache
set :scm, :git
set :branch, :master
set :scm_verbose, true
#set :user_sudo, true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  after 'deploy:update_code', 'deploy:assets_precompile'
  desc 'Precompile assets to public/assets/'
  task :assets_precompile, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end
#namespace :deploy do
#  desc 'Cause Passenger to initiate a restart.'
#  task :restart do
#    run "touch #{current_path}/tmp/restart.txt"
#  end
#
#  desc 'Reload the database with seed data.'
#  task :seed do
#    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
#  end
#
#  after 'deploy:update_code', :bundle_install
#  desc 'Install the necessary prerequisites.'
#  task :bundle_install, :roles => :app do
#    run "cd #{release_path} && bundle install"
#  end
#end
