class CreateScoreListAssessments < ActiveRecord::Migration
  def change
    create_table :score_list_assessments do |t|
      t.references :assessment, null: false
      t.references :list, null: false
      t.timestamps null: false
    end

    add_column :score_list_entries, :assessment_id, :integer
    Score::ListEntry.all.each do |list_entry|
      list_entry.update_attribute(:assessment_id, list_entry.list.assessment_id)
    end
    change_column_null :score_list_entries, :assessment_id, false

    Score::List.all.each do |list|
      Score::ListAssessment.create!(list_id: list.id, assessment_id: list.assessment_id)
    end
    remove_column :score_lists, :assessment_id
  end
end
