class AddFireSportStatisticsTeamToTeams < ActiveRecord::Migration[4.2]
  def change
    add_reference :teams, :fire_sport_statistics_team, index: true
  end
end
