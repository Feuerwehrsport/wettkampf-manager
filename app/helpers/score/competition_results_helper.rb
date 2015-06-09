module Score
  module CompetitionResultsHelper
    def table_data(competition_result)
      header = ["Punkte", "Mannschaft"]
      competition_result.results.each do |result|
        header.push(result.assessment.discipline.to_short)
        header.push("")
      end
      rows = [header]

      competition_result.rows.each do |row|
        current = [row.points.to_s, row.team.to_s]
        competition_result.results.each do |result|
          assessment_result = row.assessment_result_from(result.assessment)
          current.push(assessment_result.try(:time).try(:decorate).to_s)
          current.push(assessment_result.try(:points).to_s)
        end
        rows.push(current)
      end
      rows
    end
  end
end