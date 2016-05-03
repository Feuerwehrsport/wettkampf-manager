class AddSeriesAssessmentToScoreResults < ActiveRecord::Migration
  def change
    add_reference :score_results, :series_team_assessment, index: true
    add_reference :score_results, :series_person_assessment, index: true
  end
end
