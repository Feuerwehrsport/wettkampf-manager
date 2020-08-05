# frozen_string_literal: true

class CreateScoreResultListFactories < ActiveRecord::Migration[4.2]
  def change
    create_table :score_result_list_factories do |t|
      t.references :list_factory, index: true, null: false
      t.references :result, index: true, null: false

      t.timestamps null: false
    end
  end
end
