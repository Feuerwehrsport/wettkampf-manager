module Score
  class GroupResult < Struct.new(:result)

    def rows
      @sorted ||= calculated_rows.sort
    end

    def calculated_rows
      team_scores = {}
      competition = Competition.one
      run_count = competition.group_run_count
      score_count = competition.group_score_count

      result.rows.each do |result_row|
        next unless result_row.list_entries.first.group_competitor?
        next if result_row.entity.team.nil?

        if team_scores[result_row.entity.team].nil?
          team_scores[result_row.entity.team] = GroupResultRow.new(result_row.entity.team, score_count, run_count)
        end
        team_scores[result_row.entity.team].add_result_row(result_row)
      end
      team_scores.values.sort
    end
  end
end