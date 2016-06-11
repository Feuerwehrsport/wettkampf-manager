class AddFireSportStatisticsTeamToTeams < ActiveRecord::Migration
  def change
    add_reference :teams, :fire_sport_statistics_team, index: true
  end
end
