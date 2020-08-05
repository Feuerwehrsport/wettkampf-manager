# frozen_string_literal: true

class CreateTeamRelays < ActiveRecord::Migration[4.2]
  def change
    create_table :team_relays do |t|
      t.references :team, index: true, null: false
      t.integer :number, null: false, default: 1

      t.timestamps null: false
    end
  end
end
