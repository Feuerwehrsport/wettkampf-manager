class CreateSeriesAssessmentResults < ActiveRecord::Migration[4.2]
  def change
    create_table :series_assessment_results do |t|
      t.references :assessment, index: true, null: false
      t.references :score_result, index: true, null: false

      t.timestamps null: false
    end

    remove_column :score_results, :series_team_assessment_id, :integer
    remove_column :score_results, :series_person_assessment_id, :integer
  end
end
