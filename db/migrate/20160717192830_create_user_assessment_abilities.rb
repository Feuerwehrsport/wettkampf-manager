class CreateUserAssessmentAbilities < ActiveRecord::Migration
  def change
    create_table :user_assessment_abilities do |t|
      t.references :user, null: false, index: true
      t.references :assessment, null: false, index: true
      t.timestamps null: false
    end
  end
end
