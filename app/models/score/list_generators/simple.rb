module Score
  class ListGenerators::Simple < ListGenerator

    def perform
      entities = assessment.requests.map(&:entity).shuffle
      run = 0
      list.transaction do
        while true
          run += 1
          for track in (1..list.track_count)
            entity = entities.pop
            return if entity.nil?
            list.entries.create!(entity: entity, run: run, track: track)
          end

          if run > 1000
            asdfsadf
          end
        end
      end
    end
  end
end