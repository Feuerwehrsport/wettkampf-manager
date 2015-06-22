module FireSportStatistics
  module API
    class Get < Request
      def self.teams
        fetch("teams")
      end

      def self.competitions
        fetch("competitions")
      end

      def self.team_spellings
        fetch("team-spellings")
      end

      def self.people
        fetch("people")
      end

      def self.person_spellings
        fetch("person-spellings")
      end

      def self.team_associations
        fetch("team-associations")
      end

      def self.dcup_single_results
        logged_in_instance.post("get-dcup-single-results", year: Date.today.year)
      end

      protected

      def self.fetch type
        json_object = logged_in_instance.get("get-#{type}")
        begin
          json_object.fetch(type).map { |e| OpenStruct.new e }
        rescue KeyError => e
          raise e, OpenStruct.new(
            message: e.message,
            last_response: @@last_response,
            json_object: json_object
          )
        end
      end
    end
  end
end