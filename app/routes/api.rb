module Bronto
  class API
    require 'json'
    require 'sinatra/json'
    require 'uri'

    helpers do
      include ::Sinatra::JSON
      include Bronto::Helpers::API
      include Bronto::Helpers::Wordnet
    end

    before { etag("#{params[:word].downcase}") if settings.environment == :production }

    # API calls using BHT format
    get '/:version/:api_key/:word/?:format?' do
      query = params[:word].downcase
      synsets = $lex.lookup_synsets(query)

      words = []
      
      synsets.each do |synset|
        synset.words.map {|word| words << [word.lemma, synset.part_of_speech.to_sym] unless word.lemma == query}
        
        synset.hypernyms.each do |hypernym|
          hypernym.words.map {|word| words << [word.lemma, synset.part_of_speech.to_sym] unless word.lemma == query}
        end
      end

      synonyms = words.sort_by {|word| word.first }.uniq!
      
      hash = {}

      if synonyms
        synonyms.each do |synonym|
          hash[synonym.last] = { syn: [] } unless hash.member?(synonym.last)
          hash[synonym.last][:syn] << synonym.first
        end

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