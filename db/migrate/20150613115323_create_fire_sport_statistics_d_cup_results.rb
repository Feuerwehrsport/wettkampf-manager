class CreateFireSportStatisticsDCupResults < ActiveRecord::Migration
  def change
    create_table :fire_sport_statistics_d_cup_results do |t|
      t.string :discipline_key, null: false
      t.integer :gender, null: false
      t.boolean :youth, null: false, default: false

      t.timestamps null: false
    end
  end
end
