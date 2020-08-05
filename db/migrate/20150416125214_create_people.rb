# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[4.2]
  def change
    create_table :people do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.integer :gender, null: false
      t.references :team, index: true
      t.string :bib_number, default: '', null: false

      t.timestamps null: false
    end
  end
end
