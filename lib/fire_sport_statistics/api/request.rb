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
        @@conn ||= begin
          http = Net::HTTP.new('feuerwehrsport-statistik.de', 443)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http
        end
      end
    end
  end
end