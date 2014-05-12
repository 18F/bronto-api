module Bronto
  module Test
    module Helpers
      def json
        @json ||= JSON.parse(@api.last_response.body)
      end
    end
  end
end