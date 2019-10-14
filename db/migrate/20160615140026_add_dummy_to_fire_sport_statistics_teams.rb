class AddDummyToFireSportStatisticsTeams < ActiveRecord::Migration[4.2]
  def change
    add_column :fire_sport_statistics_teams, :dummy, :boolean, null: false, default: false
  end
end
