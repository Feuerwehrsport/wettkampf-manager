class AddTimeToScoreListEntry < ActiveRecord::Migration
  def change
    add_column :score_list_entries, :time, :integer
  end
end
