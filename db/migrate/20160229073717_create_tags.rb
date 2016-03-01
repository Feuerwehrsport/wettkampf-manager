class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.references :competition, null: false

      t.timestamps null: false
    end
  end
end
