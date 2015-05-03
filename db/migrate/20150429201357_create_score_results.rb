class CreateScoreResults < ActiveRecord::Migration
  def change
    create_table :score_results do |t|
      t.string :name, null: false, default: ""
      t.boolean :group_assessment, null: false, default: false
      t.references :assessment, index: true, null: false

      t.timestamps null: false
    end
  end
end
