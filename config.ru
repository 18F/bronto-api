require 'rubygems'
require 'sinatra'
require File.join(File.dirname(__FILE__), 'app/bronto')

map '/' do
  run Bronto::App
end

map '/api' do
  run Bronto::API
end