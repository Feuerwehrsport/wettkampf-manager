class CreateAssessmentRequests < ActiveRecord::Migration
  def change
    create_table :assessment_requests do |t|
      t.references :assessment, index: true, null: false
      t.references :entity, index: true, polymorphic: true, null: false
      t.integer :assessment_type, default: 0, null: false

      t.timestamps null: false
    end
  end
end
