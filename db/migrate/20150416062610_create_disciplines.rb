class CreateDisciplines < ActiveRecord::Migration
  def change
    create_table :disciplines do |t|
      t.string :name, null: false, default: ''
      t.string :type, null: false

      t.timestamps null: false
    end
  end
end
