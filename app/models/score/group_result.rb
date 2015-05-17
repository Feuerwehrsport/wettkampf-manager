module Score
  class GroupResult < Struct.new(:result)

    def rows
      @sorted ||= begin
        team_scores = {}
        competition = Competition.first
        run_count = competition.group_run_count
        score_count = competition.group_score_count

        result.rows.each do |score_row|
          next unless score_row.list_entries.first.group_competitor?

          if team_scores[score_row.entity.team].nil?
            team_scores[score_row.entity.team] = GroupResultRow.new(score_row.entity.team, score_count, run_count)
          end
          team_scores[score_row.entity.team].add_result_row(score_row)
        end
        team_scores.values.sort
      end
    end
  end
end