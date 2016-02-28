class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name, null: false, default: ""
      t.date :date, null: false
      t.boolean :configured, null: false, default: false
      t.boolean :group_assessment, null: false, default: false
      t.integer :group_people_count, null: false, default: 10
      t.integer :group_run_count, null: false, default: 8
      t.integer :group_score_count, null: false, default: 6
      t.boolean :show_bib_numbers, null: false, default: false

      t.timestamps null: false
    end
  end
end
