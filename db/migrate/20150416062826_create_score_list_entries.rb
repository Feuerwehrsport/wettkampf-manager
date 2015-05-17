class CreateScoreListEntries < ActiveRecord::Migration
  def change
    create_table :score_list_entries do |t|
      t.references :list, index: true, null: false
      t.references :entity, null: false, polymorphic: true
      t.integer :track, null: false
      t.integer :run, null: false
      t.string :result_type, null: false, default: "waiting"
      t.integer :assessment_type, default: 0, null: false

      t.timestamps null: false
    end
  end
end
