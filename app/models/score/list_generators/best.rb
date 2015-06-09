module Score
  class ListGenerators::Best < ListGenerator

    validates :best_count, numericality: { greater_than_or_equal_to: 0 }
    validates :result, presence: true
    validate :result_assessment_match

    def self.to_label
      "die x Besten"
    end

    def result= result_id
      @result_object = Result.find(result_id)
      super(result_id)
    end

    def perform
      result_rows = @result_object.rows.first(best_count.to_i)

      run = 0
      list.transaction do
        while true
          run += 1
          for track in (1..list.track_count)
            result_row = result_rows.pop
            p result_row
            return if result_row.nil?
            any_list = result_row.list_entries.first
            list.entries.create!(entity: result_row.entity, run: run, track: track, assessment_type: any_list.assessment_type)
          end

          if run > 1000
            asdfsadf
          end
        end
      end
    end

    private

    def result_assessment_match
      if @result_object.present? && @result_object.assessment != list.assessment
        errors.add(:result, "muss mit jetziger Wertungsgruppe übereinstimmen")
      end
    end
  end
end