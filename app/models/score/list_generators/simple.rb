module Score
  class ListGenerators::Simple < ListGenerator

    def self.to_label
      "Zufällig anordnen"
    end

    def perform
      requests = assessment.requests.to_a.shuffle
      run = 0
      list.transaction do
        while true
          run += 1
          for track in (1..list.track_count)
            request = requests.pop
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