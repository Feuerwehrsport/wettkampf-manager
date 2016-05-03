module FireSportStatistics
  module API
    class Get < Request
      def self.fetch(type)
        json_object = new.get(type)
        begin
          json_object.fetch(type.to_s.gsub("/","_")).map { |e| OpenStruct.new e }
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