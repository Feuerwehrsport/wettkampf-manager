class AddEnrolledToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :enrolled, :boolean, default: false, null: false
  end
end
