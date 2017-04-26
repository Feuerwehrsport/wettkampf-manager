class CreateAPITimeEntries < ActiveRecord::Migration
  def change
    create_table :api_time_entries do |t|
      t.integer :time, null: false
      t.string :hint
      t.string :sender
      t.datetime :used_at
      t.references :score_list_entry

      t.timestamps null: false
    end
  end
end
