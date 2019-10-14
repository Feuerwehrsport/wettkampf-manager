class CreateSeriesAssessments < ActiveRecord::Migration[4.2]
  def change
    create_table :series_assessments do |t|
      t.references :round, null: false
      t.string :discipline, null: false
      t.string :name, null: false, default: ''
      t.string :type, null: false
      t.integer :gender, null: false

      t.timestamps null: false
    end
  end
end
