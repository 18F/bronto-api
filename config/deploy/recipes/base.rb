def smoke_test()
  find_servers_for_task(current_task).each do |current_server|
    ip_via_bash = "/sbin/ifconfig eth0 | grep 'inet addr' | awk -F: '{print $2}' | awk '{print $1}'"
    set :ip, capture(ip_via_bash, hosts: current_server.host).scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/).first
    run "ruby #{File.join(current_path,'lib','smoke_test.rb')} http://#{ip}"
  end
end

def change_config( setting_name, from, to )
  filename = "#{current_path}/config/settings.yml"
  outdata = File.read(filename).read.gsub(/#{setting_name}\s*:\s*#{from}/, "#{setting_name}: #{to}")
  File.open( outfile, 'w') do |out|
    out << outdata
  end
end

# Helper method to upload to /tmp then use sudo to move to correct location.
def put_sudo(data, to, hosts)
  filename = File.basename(to)
  to_directory = File.dirname(to)

  # create temp file
  put data, "/tmp/#{filename}", hosts: hosts
  
  # create time stamped backup file if one exists  
  run "if [[ -f #{to_directory}/#{filename} ]]; then #{sudo} cp #{to_directory}/#{filename} #{to_directory}/#{filename}.#{Time.now.strftime('%Y.%m.%d.%H.%M')}.bak; fi", hosts: hosts

  # move tmp file to destination
  sudo "mv -f /tmp/#{filename} #{to_directory}/", hosts: hosts
end
 
# Helper method to create ERB template then upload using sudo privileges (modified from rbates)
def template_sudo(from, to, locals={})
  find_servers_for_task(current_task).each_with_index do |current_server,i|
    ip_via_bash = "/sbin/ifconfig eth0 | grep 'inet addr' | awk -F: '{print $2}' | awk '{print $1}'"
    set :ip, capture(ip_via_bash, hosts: current_server.host).scan(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/).first
    set :new_relic_server_number, "%02d" % (i+1)
    erb = File.read(File.expand_path("../../templates/#{from}", __FILE__))
    put_sudo ERB.new(erb).result(binding), to, current_server.host
  end
end

def template(from, to)
  erb = File.read(File.expand_path("../../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "run smoke tests"
  task :smoke, roles: :app do
    smoke_test
  end

  desc "chown & chmod to nginx:rvm"
  task :chown, roles: :app do
    sudo "chown -R #{user}:rvm #{deploy_to}"
    sudo "chmod -R 775 #{deploy_to}"
  end

  desc "Add config dir to shared folder"
  task :add_shared_config, roles: :app do
    run "#{try_sudo} mkdir -p #{deploy_to}/shared/config"
  end

  desc "Upload configuration files"
  task :upload_configs, roles: :app do
    Dir.glob('config/*.yml').each {|cfg| top.upload cfg, "#{deploy_to}/shared/config/", via: :scp }
  end

  desc "Symlink configs"
  task :symlink_configs, roles: :app do
    run "#{try_sudo} ln -nfs #{deploy_to}/shared/config/newrelic.yml #{current_path}/config/"
    run "#{try_sudo} ln -nfs #{deploy_to}/shared/config/settings.yml #{current_path}/config/"
  end

  desc <<-DESC
    [internal] Touches up the released code. This is called by update_code \
    after the basic deploy finishes. It assumes a Rails project was deployed, \
    so if you are deploying something else, you may want to override this \
    task with your own environment's requirements.

    This task will make the release group-writable (if the :group_writable \
    variable is set to true, which is the default). It will then set up \
    symlinks to the shared directory for the log, system, and tmp/pids \
    directories, and will lastly touch all assets in public/images, \
    public/stylesheets, and public/javascripts so that the times are \
    consistent (so that asset timestamping works).  This touch process \
    is only carried out if the :normalize_asset_timestamps variable is \
    set to true, which is the default. The asset directories can be overridden \
    using the :public_children variable.
  DESC
  task :finalize_update, roles: :app, except: { no_release: true } do
    escaped_release = latest_release.to_s.shellescape
    commands = []
    commands << "chmod -R -- g+w #{escaped_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    shared_children.map do |dir|
      d = dir.shellescape
      if (dir.rindex('/')) then
        commands += ["rm -rf -- #{escaped_release}/#{d}",
                     "mkdir -p -- #{escaped_release}/#{dir.slice(0..(dir.rindex('/'))).shellescape}"]
      else
        commands << "rm -rf -- #{escaped_release}/#{d}"
      end
      commands << "#{try_sudo} ln -s -- #{shared_path}/#{dir.split('/').last.shellescape} #{escaped_release}/#{d}"
    end

    run commands.join(' && ') if commands.any?

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:public_children, %w(javascripts)). # images stylesheets
        map { |p| "#{latest_release}/public/#{p}" }.
        map { |p| p.shellescape }
      run("find #{asset_paths.join(" ")} -exec touch -t #{stamp} -- {} ';'; true",
          :env => { "TZ" => "UTC" }) if asset_paths.any?
    end
    chown
  end
end
