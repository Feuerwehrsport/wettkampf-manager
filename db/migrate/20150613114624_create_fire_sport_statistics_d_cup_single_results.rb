class CreateFireSportStatisticsDCupSingleResults < ActiveRecord::Migration
  def change
    create_table :fire_sport_statistics_d_cup_single_results do |t|
      t.references :result, null: false, index: true
      t.references :person, index: true, null: false
      t.references :competition, null: false
      t.integer :points, null: false, default: 0
      t.integer :time

      t.timestamps null: false
    end

    add_index :fire_sport_statistics_d_cup_single_results, :competition_id, name: :fire_sport_statistics_d_cup_single_competition_id
  end
end
