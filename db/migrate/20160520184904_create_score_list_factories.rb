# frozen_string_literal: true

class CreateScoreListFactories < ActiveRecord::Migration[4.2]
  def change
    create_table :score_list_factories do |t|
      t.string :session_id
      t.references :discipline, null: false
      t.string :name
      t.string :shortcut
      t.integer :track_count
      t.string :type
      t.references :before_result
      t.references :before_list
      t.integer :best_count
      t.string :status

      t.timestamps null: false
    end
  end
end
