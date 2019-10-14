class AddTimeToScoreListEntry < ActiveRecord::Migration[4.2]
  def change
    add_column :score_list_entries, :time, :integer
  end
end
