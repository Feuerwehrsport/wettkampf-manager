module Score
  class CompetitionResult
    def dcup
      [:female, :male].map do |gender|
        teams = {}
        Result.group_assessment_for(gender).each do |result|
          discipline = result.assessment.discipline
          if result.group_assessment? && discipline.single_discipline?
            result_rows = GroupResult.new(result).rows
          elsif result.group_assessment?
            result_rows = result.rows
          end

          points = 11
          current_assessment_results = []
          result_rows.each do |row|
            points -= 1 if points > 0
            assessment_result = AssessmentResult.new(row.competition_result_valid? ? points : 0, result.assessment, row.time, row.entity, row)
            teams[row.entity.id] = CompetitionResultRow.new(row.entity) if teams[row.entity.id].nil?
            teams[row.entity.id].add_assessment_result(assessment_result)
            current_assessment_results.push(assessment_result)
          end

          loop do
            assessment_result = current_assessment_results.pop
            break if assessment_result.blank?
            break if assessment_result.points == 0 && assessment_result.row.competition_result_valid?
            break if assessment_result.row.valid?
            assessment_result.points = points
          end
        end
        teams.values.sort
      end
    end
  end
end