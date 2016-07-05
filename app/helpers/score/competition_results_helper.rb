module Score::CompetitionResultsHelper
  def table_data(competition_result, shortcut)
    header = ["Punkte", "Mannschaft"]
    competition_result.results.each do |result|
      header.push(result.assessment.discipline.to_short)
      header.push("")
    end
    rows = [header]

    competition_result.rows.each do |row|
      team = shortcut ? row.team.shortcut_name : row.team.to_s
      current = [row.points.to_s, team]
      competition_result.results.each do |result|
        assessment_result = row.assessment_result_from(result.assessment)
        current.push(assessment_result.try(:result_entry).try(:decorate).to_s)
        current.push(assessment_result.try(:points).to_s)
      end
      rows.push(current)
    end
    rows
  end
end