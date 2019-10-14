class CreateScoreListFactoryAssessments < ActiveRecord::Migration[4.2]
  def change
    create_table :score_list_factory_assessments do |t|
      t.references :assessment, null: false, index: true
      t.references :list_factory, null: false, index: true

      t.timestamps null: false
    end
  end
end
