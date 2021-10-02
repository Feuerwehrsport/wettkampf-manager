class AddHiddenToScoreLists < ActiveRecord::Migration[5.2]
  def change
    add_column :score_lists, :hidden, :boolean, default: false, null: false
    add_column :score_list_factories, :hidden, :boolean, default: false, null: false
  end
end
