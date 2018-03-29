class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.string :name, null: false, default: ''
      t.references :discipline, index: true, null: false
      t.integer :gender

      t.timestamps null: false
    end
  end
end
