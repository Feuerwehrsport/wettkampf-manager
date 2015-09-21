module Score
  class ListGenerators::Best < ListGenerator
    validates :best_count, numericality: { greater_than_or_equal_to: 0 }
    validates :result, presence: true
    validate :result_assessments_match

    def result= result_id
      @result_object = Result.find(result_id)
      super(result_id)
    end

    protected

    def create_list_entry result_row, run, track
      any_list = result_row.list_entries.first
      list.entries.create!(
        entity: result_row.entity, 
        run: run, 
        track: track, 
        assessment_type: any_list.assessment_type,
        assessment: result_row.result.assessment
      )
    end

    private

    def result_rows
      @result_object.rows
    end

    def perform_rows
      all_rows = result_rows.dup
      result_rows = all_rows.shift(best_count.to_i)
      while all_rows.count > 0 && (result_rows.last <=> all_rows.first) == 0
        result_rows.push(all_rows.shift)
      end
      result_rows.reverse
    end

    def result_assessments_match
      if list.assessments.length != 1
        errors.add(:base, "Es darf nur eine Wertungsgruppe ausgewählt werden")
      elsif @result_object.present? && @result_object.assessment != list.assessments.first
        errors.add(:result, "muss mit jetziger Wertungsgruppe übereinstimmen")
      end
    end
  end
end