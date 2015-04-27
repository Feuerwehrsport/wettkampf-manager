class CreateFireSportStatisticsTeams < ActiveRecord::Migration
  def change
    create_table :fire_sport_statistics_teams do |t|
      t.string :name, null: false
      t.string :short, null: false
      t.string :external_id, null: false

      t.timestamps null: false
    end
    add_index :fire_sport_statistics_teams, :external_id
  end
end
