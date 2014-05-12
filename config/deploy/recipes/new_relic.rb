require 'new_relic/recipes'

after "deploy:update", "newrelic:notice_deployment"

set :prefix, '/usr/local'
set :install_dir, "#{prefix}/src/newrelic_nginx_agent"

namespace :new_relic do
	namespace :nginx_daemon do
	  desc "Install New Relic daemon"
	  task :install do

	    sudo "wget http://nginx.com/download/newrelic/newrelic_nginx_agent.tar.gz -O #{prefix}/src/newrelic_nginx_agent.tar.gz"
	    sudo "tar xzvf #{prefix}/src/newrelic_nginx_agent.tar.gz -C #{prefix}/src/"
	    run "rvmsudo bundle install --gemfile #{install_dir}/Gemfile"
	    config
	    symlink_daemon
	    start
	    ping
	    status
	  end

	  task :config do
	    # add code and backup file if it exists
	    template_sudo 'newrelic_plugin.yml.erb', "#{install_dir}/config/newrelic_plugin.yml"
	    sudo "ln -nfs #{install_dir}/config/newrelic_plugin.yml #{prefix}/etc/"	  	
	  end

	  task :symlink_daemon do
	    sudo "ln -nfs #{install_dir}/newrelic_nginx_agent.daemon #{prefix}/sbin/newrelic_nginx_agent"
	  end

	  desc 'Start the New Relic daemon'
 	  task :start do
			run "rvmsudo #{prefix}/sbin/newrelic_nginx_agent start"
		end

	  desc 'Stop the New Relic daemon'
 	  task :stop do
			run "rvmsudo #{prefix}/sbin/newrelic_nginx_agent start"		
		end

	  desc 'Restart the New Relic daemon'
 	  task :restart do
			run "rvmsudo #{prefix}/sbin/newrelic_nginx_agent restart"
		end

	  desc 'Ping the New Relic daemon'
 	  task :ping do
	    run "curl http://localhost/nginx_stub_status"
		end

	  desc 'Get the status of the New Relic daemon'
 	  task :status do
			run "rvmsudo #{prefix}/sbin/newrelic_nginx_agent status"		
		end

	end # namespace :nginx_daemon
end # namespace :new_relic
