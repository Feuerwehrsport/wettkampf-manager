class CreateImportsConfigurations < ActiveRecord::Migration
  def change
    create_table :imports_configurations do |t|
      t.string :file, null: false
      t.datetime :executed_at
      t.text :data, null: false, default: '{}'

      t.timestamps null: false
    end
  end
end
