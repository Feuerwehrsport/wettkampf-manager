class AddDoubleEventResultToScoreResults < ActiveRecord::Migration
  def change
    add_column :score_results, :double_event_result_id, :integer
    add_column :score_results, :type, :string, default: "Score::Result", null: false
    add_index :score_results, :double_event_result_id
  end
end
