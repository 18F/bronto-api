require 'rubygems'
require 'bundler'
require 'rake'
Bundler.setup

Dir["tasks/*.rake"].sort.each { |ext| load ext }

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec