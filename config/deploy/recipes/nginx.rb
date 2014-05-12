namespace :nginx do
  desc "Create nginx configuration from template"
  task :add_config, roles: :app do
    # add code to backup file if it exists
    template_sudo 'nginx.conf.erb', '/opt/nginx/conf/nginx.conf'
  end

  desc "Create nginx configuration from template and reload server"
  task :update_config, role: :app do
    add_config
    reload
  end

  desc "Add init.d script"
  task :init_d, roles: :app do
    dest = '/etc/init.d/nginx'
    template_sudo 'nginx.initd.rhel.erb', dest
    sudo "chown root:root #{dest}"
    sudo "chmod +x #{dest}"
    sudo '/sbin/chkconfig nginx on'
    sudo '/sbin/chkconfig --list nginx'
  end

  desc "Nginx configuration test"
  task :configtest, role: :app do
    sudo "service nginx configtest"
  end

  desc "Nginx configuration test"
  task :status, role: :app do
    sudo "service nginx status"
  end

  desc "Reload nginx server"
  task :reload, role: :app do
    sudo "service nginx reload"
  end

  desc "Restart nginx server"
  task :restart, role: :app do
    sudo "service nginx restart"
  end

  desc "Add nginx user to system"
  task :add_user, role: :app do
    sudo "useradd nginx"
  end

  desc "Setup nginx env"
  task :setup, role: :app do
    init_d
    add_config
    configtest
    restart
  end
end