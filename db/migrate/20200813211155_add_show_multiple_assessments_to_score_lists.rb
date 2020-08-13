class AddShowMultipleAssessmentsToScoreLists < ActiveRecord::Migration[5.2]
  def change
    add_column :score_lists, :show_multiple_assessments, :boolean, default: true
  end
end
