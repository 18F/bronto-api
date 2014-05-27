ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start
require 'rspec_api_blueprint'

require File.expand_path '../../app/bronto.rb', __FILE__
#require 'spec/support/json'
#require 'spec/support/sinatra'

module Bronto
  module Test
    module Helpers
      def json
        @json ||= JSON.parse(@api.last_response.body)
      end
    end
  end
end

require 'rack/test'

module SinatraApps
	def app() Bronto::App end
	def api() Bronto::API end
end
 
RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.include Bronto::Test::Helpers
  c.include SinatraApps
end