module Score
  class CompetitionResult
    def dcup
      [:female, :male].map do |gender|
        teams = {}
        Result.group_assessment_for(gender).each do |result|
          discipline = result.assessment.discipline
          if result.group_assessment? && discipline.single_discipline?
            result_rows = GroupResult.new(result).rows
          else
            result_rows = result.rows
          end

          points = 10
          result_rows.each do |row|
            assessment_result = AssessmentResult.new(row.valid? ? points : 0, result.assessment, row.time, row.entity)
            points -= 1 if points > 0
            teams[row.entity.id] = CompetitionResultRow.new(row.entity) if teams[row.entity.id].nil?
            teams[row.entity.id].add_assessment_result(assessment_result)
          end
        end
        teams.values.sort
      end
    end
  end
end