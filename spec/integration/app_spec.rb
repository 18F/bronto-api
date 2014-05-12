require File.expand_path '../../spec_helper.rb', __FILE__

describe Bronto::App do
	describe 'GET /' do
	 	context 'when no words are entered' do
		 	before { get '/' }
	
		 	it 'returns a 200 status code' do
		 		pending
				expect(last_response.status).to eq 404
			end

			it 'returns a form to enter a word' do |variable|
				pending
				expect(json).to eq({"result"=>"Word not found"})
			end
		end

		context 'when a word is entered' do
		 	before do
		 		post '/', q: 'fish'
		 	end

		 	it 'returns a 200 status code' do
		 		pending
			  expect(last_response.status).to eq 200
			end

			it 'returns a list of synoyms' do
				pending
				expect(json).to eq(JSON.parse(File.open("#{Dir.pwd}/spec/fixtures/fish-response.json").read))
			end

		end

	end 
end 