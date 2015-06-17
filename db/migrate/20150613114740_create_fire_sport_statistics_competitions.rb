class CreateFireSportStatisticsCompetitions < ActiveRecord::Migration
  def change
    create_table :fire_sport_statistics_competitions do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.integer :external_id, null: false

      t.timestamps null: false
    end
  end
end
