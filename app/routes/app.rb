module Bronto
  class App

    before { etag("#{params[:word].downcase}") if  [:production, :test].include?(settings.environment) }

    helpers do
      include Bronto::Helpers::App
      #include Bronto::Helpers::Wordnet
    end

    before { etag("#{params[:word].downcase}") if settings.environment == :production }

    get('/') { slim :index }

    post '/' do
      redirect "/#{params[:q]}"
    end

    get '/:word' do
      @syns = $lex.lookup_synsets(params[:word])
      slim :word
    end
  end
end
