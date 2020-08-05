# frozen_string_literal: true

class AddScoreCountToResults < ActiveRecord::Migration[4.2]
  def change
    add_column :score_results, :group_score_count, :integer
    add_column :score_results, :group_run_count, :integer
  end
end
