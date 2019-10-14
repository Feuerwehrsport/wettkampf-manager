class AddShortcutToTeams < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :shortcut, :string, null: false, default: ''
    Team.reset_column_information
    Team.all.each do |team|
      team.update_attribute(:shortcut, team.name.truncate(12))
    end
  end
end
