# frozen_string_literal: true

class CreateFireSportStatisticsPeople < ActiveRecord::Migration[4.2]
  def change
    create_table :fire_sport_statistics_people do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.integer :gender, null: false

      t.timestamps null: false
    end
  end
end
