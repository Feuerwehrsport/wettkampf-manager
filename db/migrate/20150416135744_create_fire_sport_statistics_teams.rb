class CreateFireSportStatisticsTeams < ActiveRecord::Migration[4.2]
  def change
    create_table :fire_sport_statistics_teams do |t|
      t.string :name, null: false
      t.string :short, null: false

      t.timestamps null: false
    end
  end
end
