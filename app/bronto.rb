require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'sinatra/base'
require 'sinatra/json'
require 'logger'
require 'wordnet'

# Development-specific options
if [:test, :development, :console].include?(settings.environment)
  require 'pry'
  require 'pry-nav'
end

module Bronto
  class Main < Sinatra::Base
    configure do
      set :app_file, __FILE__
      # Don't log them. We'll do that ourself
      set :dump_errors, false
      set :logging, ENV['RACK_ENV'] == 'production' ? ::Logger::ERROR : ::Logger::DEBUG
      # Don't capture any errors. Throw them up the stack
      set :raise_errors, true
      # set :sessions, false
      set :server, %w[thin webrick]
      set :static_cache_control, [:public, :max_age => 1209600]
      use Rack::CommonLogger
    end

    # Development-specific options
    if [:test, :development, :console].include?(settings.environment)
      require 'pry'
      require 'pry-nav'
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end  

  class App < Main
    set :show_exceptions, true    
    set :views, Proc.new { File.join(root, 'views') }
  end
  
  class API < Main
    require 'sinatra/respond_with'
    set :json_encoder, :to_json
  end

  # load settings
  SETTINGS =  YAML::load_file(File.expand_path("../../config/settings.yml", __FILE__))

  require_relative 'helpers/init'
  require_relative 'routes/init'
end