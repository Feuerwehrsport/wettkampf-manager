module Score
  class ListGenerators::FireRelay < ListGenerator

    def self.to_label
      "Staffellauf mit A, B"
    end

    def perform
      number_requests = {}
      assessment.requests.to_a.shuffle.each do |request|
        (1..request.relay_count).each do |number|
          number_requests[number] ||= []
          relay = TeamRelay.find_or_create_by!(team: request.entity, name: TeamRelay.name_for_number(number))
          number_requests[number].push(OpenStruct.new(entity: relay, assessment_type: request.assessment_type))
        end
      end
      relay_requests = number_requests.values.flatten.reverse
      
      run = 0
      list.transaction do
        while true
          run += 1
          for track in (1..list.track_count)
            request = relay_requests.pop
            return if request.nil?
            list.entries.create!(entity: request.entity, run: run, track: track, assessment_type: request.assessment_type)
          end

          if run > 1000
            asdfsadf
          end
        end
      end
    end
  end
end