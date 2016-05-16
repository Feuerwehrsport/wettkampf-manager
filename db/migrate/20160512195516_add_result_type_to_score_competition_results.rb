class AddResultTypeToScoreCompetitionResults < ActiveRecord::Migration
  def change
    add_column :score_competition_results, :result_type, :string
  end
end
