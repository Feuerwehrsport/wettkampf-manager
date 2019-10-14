class AddDateToScoreLists < ActiveRecord::Migration[4.2]
  def change
    add_column :score_lists, :date, :date
    add_column :score_results, :date, :date
  end
end
