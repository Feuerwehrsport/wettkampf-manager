require 'net/http'
require 'json'

module FireSportStatistics
  module API
    class Request
      def initialize
        @@last_response ||= nil
      end

      def get(type)
        handle_response(conn.get(path(type)))
      end

      protected

      def path(type)
        "/api/#{type}"
      end

      def handle_response(response)
        @@last_response = response
        JSON.parse(response.body)
      end
   
      def conn
        @@conn ||= Net::HTTP.new("www.feuerwehrsport-statistik.de", 80)
      end
    end
  end
end