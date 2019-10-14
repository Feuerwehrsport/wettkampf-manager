class CreateScoreResultLists < ActiveRecord::Migration[4.2]
  def change
    create_table :score_result_lists do |t|
      t.references :list, index: true, null: false
      t.references :result, index: true, null: false

      t.timestamps null: false
    end

    remove_column :score_lists, :result_id, :integer
  end
end
