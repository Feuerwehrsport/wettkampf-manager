# frozen_string_literal: true

class CreateFireSportStatisticsTeamSpellings < ActiveRecord::Migration[4.2]
  def change
    create_table :fire_sport_statistics_team_spellings do |t|
      t.string :name, null: false
      t.string :short, null: false
      t.references :team, index: true, null: false

      t.timestamps null: false
    end
  end
end
