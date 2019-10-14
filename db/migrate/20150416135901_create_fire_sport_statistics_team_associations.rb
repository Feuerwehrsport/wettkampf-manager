class CreateFireSportStatisticsTeamAssociations < ActiveRecord::Migration[4.2]
  def change
    create_table :fire_sport_statistics_team_associations do |t|
      t.references :person, index: true, null: false
      t.references :team, index: true, null: false

      t.timestamps null: false
    end
  end
end
