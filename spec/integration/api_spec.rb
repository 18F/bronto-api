require File.expand_path '../../spec_helper.rb', __FILE__

describe Bronto::API, :type => :api do
	before { @api = browser = Rack::Test::Session.new(Rack::MockSession.new(api)) }

	describe 'GET /api/{version}/{api-key}/{word}/{format}' do

	 	context 'when no words are entered' do
		 	before { @api.get '/1/api-key/' }
	
		 	it 'returns a 404 status code' do
				expect(@api.last_response.status).to eq 404
			end

			it 'returns an error message in json' do |variable|
				expect(json).to eq({"result"=>"Word not found"})
			end
		end

		context 'when the url is malformed' do
		 	before { @api.get '/1api-key/fish/json' }
	
		 	it 'returns a 404 status code' do
				expect(@api.last_response.status).to eq 404
			end
		end

		context 'when a word is entered' do
		 	before do
		 		@api.get '/1/api-key/fish/json'
		 	end

		 	it 'returns a 200 status code' do
			  expect(@api.last_response.status).to eq 200
			end

			it 'returns a hash of synoyms grouped by part of speech' do
				expect(json).to eq(JSON.parse(File.open("#{Dir.pwd}/spec/fixtures/fish-response.json").read))
			end

		end

	end 
end 