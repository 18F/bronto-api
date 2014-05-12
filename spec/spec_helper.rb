ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start
require 'rspec_api_blueprint'

require File.expand_path '../../app/bronto.rb', __FILE__
require 'spec/support/json'
require 'spec/support/sinatra'
 
RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.include Bronto::Test::Helpers
  c.include SinatraApps
end