# frozen_string_literal: true

class CreateImportsAssessments < ActiveRecord::Migration[4.2]
  def change
    create_table :imports_assessments do |t|
      t.integer :foreign_key, null: false, index: true
      t.references :configuration, index: true, null: true
      t.string :name, null: true
      t.string :gender, null: true
      t.string :discipline, null: true
      t.references :assessment, index: true

      t.timestamps null: false
    end
  end
end
