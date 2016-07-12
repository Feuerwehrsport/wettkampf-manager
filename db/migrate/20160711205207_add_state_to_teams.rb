class AddStateToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :federal_state_id, :integer
    add_index :teams, :federal_state_id
    add_column :fire_sport_statistics_teams, :federal_state_id, :integer
    add_index :fire_sport_statistics_teams, :federal_state_id
  end
end
