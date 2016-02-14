module FireSportStatistics
  module API
    class Get < Request
      def self.dcup_single_results
        logged_in_instance.post("get-dcup-single-results", year: Date.today.year)
      end

      protected

      def self.fetch(type)
        json_object = new.get(type)
        begin
          json_object.fetch(type.to_s).map { |e| OpenStruct.new e }
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