class AddResultTypeToScoreCompetitionResults < ActiveRecord::Migration[4.2]
  def change
    add_column :score_competition_results, :result_type, :string
  end
end
