namespace :git do
  desc "Install git from yum"
  task :install, roles: :app do
    run "#{sudo} yum install git -y"
  end
end