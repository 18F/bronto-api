module Bronto
  class API
    require 'json'
    require 'sinatra/json'
    require 'uri'

    helpers do
      include ::Sinatra::JSON
      include Bronto::Helpers::API
    end

    before { etag("#{params[:word].downcase}") if settings.environment == :production }

    # API calls using BHT format
    get '/:version/:api_key/:word/?:format?' do
      query = params[:word].downcase
      
      hash = BrontoGem.lookup(query)

      if hash
        json hash
      else
        status 404
        json({ result: 'Word not found' })
      end
    end

    not_found do
      status 404
      json({ result: 'Word not found' })
    end

    error do
      status 500
      json({ result: 'There was an error' })
    end

  end # end class
end # end module