source "https://rubygems.org"

gem 'rake'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'slim'
gem 'sqlite3'

# this works (assuming the the `path` properly points to a local copy of bronto-gem.git)
#gem 'bronto-gem', path: '../bronto-gem'

# pulling from github until we host on rubygems.org
# this does not work.
gem 'bronto-gem', '~>0.0'#, git: 'https://github.com/adelevie/bronto-gem.git', branch: 'master'


group :development, :test do
  # Sass & Compass
  gem 'bootstrap-sass'
  gem 'compass'
  gem 'capistrano', '~> 2.15'
  gem 'brakeman'
  gem 'capybara'
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry-rescue'
  gem 'pry-nav'
  gem 'rdoc'
  gem 'rspec'
  gem 'rspec_api_blueprint', require: false
  gem 'rvm'
  gem 'rvm-capistrano'
  gem 'simplecov'
  gem 'shotgun'
  gem 'thin'
end