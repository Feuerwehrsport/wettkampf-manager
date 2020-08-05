# frozen_string_literal: true

class CreateAssessments < ActiveRecord::Migration[4.2]
  def change
    create_table :assessments do |t|
      t.string :name, null: false, default: ''
      t.references :discipline, index: true, null: false
      t.integer :gender

      t.timestamps null: false
    end
  end
end
