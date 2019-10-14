class CreateScoreCompetitionResults < ActiveRecord::Migration[4.2]
  def change
    create_table :score_competition_results do |t|
      t.string :name
      t.integer :gender
      t.timestamps null: false
    end

    add_column :assessments, :score_competition_result_id, :integer
    add_index :assessments, :score_competition_result_id
  end
end
