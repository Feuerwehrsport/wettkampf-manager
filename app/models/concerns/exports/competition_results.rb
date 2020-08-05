# frozen_string_literal: true

module Exports::CompetitionResults
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

      current = ["#{competition_result.place_for_row(row)}.", team]
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
end
