# frozen_string_literal: true

class CreateDisciplines < ActiveRecord::Migration[4.2]
  def change
    create_table :disciplines do |t|
      t.string :name, null: false, default: ''
      t.string :type, null: false

      t.timestamps null: false
    end
  end
end
