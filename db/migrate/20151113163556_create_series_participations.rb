class CreateSeriesParticipations < ActiveRecord::Migration[4.2]
  def change
    create_table :series_participations do |t|
      t.references :assessment, null: false
      t.references :cup, null: false
      t.string :type, null: false

      t.references :team, null: true
      t.integer :team_number, null: true

      t.references :person, null: true

      t.integer :time, null: false
      t.integer :points, null: false, default: 0
      t.integer :rank, null: false

      t.timestamps null: false
    end
  end
end
