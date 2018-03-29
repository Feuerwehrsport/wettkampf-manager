class CreateScoreLists < ActiveRecord::Migration
  def change
    create_table :score_lists do |t|
      t.string :name, null: false, default: ''
      t.integer :track_count, null: false, default: 2
      t.references :assessment, index: true, null: false
      t.references :result, index: true

      t.timestamps null: false
    end
  end
end
