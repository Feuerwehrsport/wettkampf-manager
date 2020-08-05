# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[4.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.integer :gender, null: false
      t.integer :number, null: false, default: 1

      t.timestamps null: false
    end
  end
end
