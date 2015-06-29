class AddShortcutToScoreLists < ActiveRecord::Migration
  def change
    add_column :score_lists, :shortcut, :string, default: "", null: false
  end
end
