class CreateFireSportStatisticsPeople < ActiveRecord::Migration
  def change
    create_table :fire_sport_statistics_people do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.integer :gender, null: false
      t.string :external_id, null: false

      t.timestamps null: false
    end
    add_index :fire_sport_statistics_people, :external_id
  end
end
