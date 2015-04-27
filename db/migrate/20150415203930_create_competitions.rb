class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name, null: false, default: ""
      t.date :date, null: false
      t.boolean :configured, null: false, default: false

      t.timestamps null: false
    end
  end
end
