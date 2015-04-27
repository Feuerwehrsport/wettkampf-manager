class CreateScoreStopwatchTimes < ActiveRecord::Migration
  def change
    create_table :score_stopwatch_times do |t|
      t.references :list_entry, index: true, null: false
      t.integer :time, null: false
      t.string :type, null: false

      t.timestamps null: false
    end
  end
end
