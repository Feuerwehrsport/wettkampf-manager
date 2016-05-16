class AddScoreCountToResults < ActiveRecord::Migration
  def change
    add_column :score_results, :group_score_count, :integer
    add_column :score_results, :group_run_count, :integer
  end
end
