module Score::CompetitionResultsHelper
  def table_data(competition_result)
    header = %w[Platz Mannschaft]
    competition_result.results.each do |result|
      header.push(result.assessment.discipline.to_short)
      header.push('')
    end
    header.push('Punkte')
    rows = [header]

    all_rows = competition_result.rows
    all_rows.each do |row|
      team = row.team.to_s

      current = ["#{place_for_row(row, all_rows)}.", team]
      competition_result.results.each do |result|
        assessment_result = row.assessment_result_from(result.assessment)
        current.push(assessment_result.try(:result_entry).try(:decorate).to_s)
        current.push(assessment_result.try(:points).to_s)
      end
      current.push(row.points.to_s)
      rows.push(current)
    end
    rows
  end

  def place_for_row(row, rows)
    rows.each_with_index do |place_row, place|
      return (place + 1) if (row <=> place_row).zero?
    end
  end
end
