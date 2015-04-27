require 'net/http'
require 'json'

module FireSportStatistics
  module API
    class Request
      def initialize
        @@headers ||= {}
        @@last_response ||= nil
      end

      def self.logged_in_instance
        new.login
      end

      def login
        post("login", name: Rails.application.class.parent_name, email: "")
        self
      end

      def post type, params
        handle_response conn.post(path(type), params.to_param, @@headers)
      end

      def get type
        handle_response conn.get(path(type), @@headers)
      end

      protected

      def path type
        params = { type: type, api: "1" }
        "/json.php?#{params.to_param}"
      end

      def handle_response response
        @@last_response = response
        cookie = response.response['set-cookie']
        @@headers["Cookie"] = cookie if cookie
        JSON.parse(response.body)
      end
   
      def conn
        @@conn ||= Net::HTTP.new("www.feuerwehrsport-statistik.de", 80)
      end
    end
  end
end