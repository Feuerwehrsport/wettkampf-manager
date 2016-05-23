class CreateScoreResultListFactories < ActiveRecord::Migration
  def change
    create_table :score_result_list_factories do |t|
      t.references :list_factory, index: true, null: false
      t.references :result, index: true, null: false

      t.timestamps null: false
    end
  end
end
