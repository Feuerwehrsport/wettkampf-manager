class AddDummyToFireSportStatisticsTeams < ActiveRecord::Migration
  def change
    add_column :fire_sport_statistics_teams, :dummy, :boolean, null: false, default: false
  end
end
