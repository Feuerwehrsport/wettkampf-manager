class AddShortcutToScoreLists < ActiveRecord::Migration[4.2]
  def change
    add_column :score_lists, :shortcut, :string, default: '', null: false
  end
end
