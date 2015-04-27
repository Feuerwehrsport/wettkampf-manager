class CreateFireSportStatisticsPersonSpellings < ActiveRecord::Migration
  def change
    create_table :fire_sport_statistics_person_spellings do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.integer :gender, null: false
      t.references :person, index: true, null: false

      t.timestamps null: false
    end
  end
end
