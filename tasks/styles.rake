desc 'Start compass'
task compass: ['compass:start']

namespace :compass do
  task :start do
    puts 'Starting compass'
    system 'compass watch -c config/initializers/compass.rb -r bootstrap-sass --app-dir .'
  end
end

namespace :css do

  desc 'Clear the CSS'
  task clear: ['compile:clear']

  desc 'Compile CSS'
  task compile: ['compile:default']

  
  namespace :compile do

    task :clear do
      puts '*** Clearing CSS ***'
      system 'rm -Rfv public/stylesheets/*'
    end

    task default: :clear do
      puts '*** Compiling CSS ***'
      system 'compass compile -c config/initializers/compass.rb -r bootstrap-sass --app-dir .'
    end

    desc 'Compile CSS for production'
    task prod: :clear do
      puts '*** Compiling CSS ***'
      system 'compass compile -c config/initializers/compass.rb -r bootstrap-sass --app-dir . --output-style compressed --force'
    end

  end

end
