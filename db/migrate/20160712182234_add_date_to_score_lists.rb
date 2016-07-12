class AddDateToScoreLists < ActiveRecord::Migration
  def change
    add_column :score_lists, :date, :date
    add_column :score_results, :date, :date
  end
end
