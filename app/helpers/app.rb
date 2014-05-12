#require 'faraday'
#require 'faraday/digest-auth'

module Bronto
  module Helpers
    module App

      def partial(page, options={})
        options[:locals].map { |key, value| instance_variable_set "@#{key}", value} if options[:locals]
        slim "_#{page}".to_sym, options.merge!(:layout => false)
      end

    end
  end
end