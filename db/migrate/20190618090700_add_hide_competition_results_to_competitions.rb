class AddHideCompetitionResultsToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :hide_competition_results, :boolean, default: false, null: false
  end
end
