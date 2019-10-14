class CreateSeriesCups < ActiveRecord::Migration[4.2]
  def change
    create_table :series_cups do |t|
      t.references :round, null: false
      t.string :competition_place, null: false
      t.date :competition_date, null: false
      t.timestamps null: false
    end
  end
end
