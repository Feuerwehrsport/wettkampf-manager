module Score
  module CompetitionResultsHelper
    def group_results_for gender
      @group_results ||= {}
      @group_results[gender] ||= Result.group_assessment_for(gender).decorate
    end

    def table_data(gender, collection)
      header = ["Punkte", "Mannschaft"]
      group_results_for(gender).each do |result|
        header.push(result.assessment.discipline.to_short)
        header.push("")
      end
      rows = [header]
      collection.each do |row|
        current = [row.points.to_s, row.team.to_s]
        group_results_for(gender).each do |result|
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