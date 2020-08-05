# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[4.2]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.references :competition, null: false

      t.timestamps null: false
    end
  end
end
