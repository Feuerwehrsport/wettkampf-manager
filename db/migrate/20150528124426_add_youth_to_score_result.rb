class AddYouthToScoreResult < ActiveRecord::Migration
  def change
    add_column :score_results, :youth, :boolean, default: false, null: false
  end
end
