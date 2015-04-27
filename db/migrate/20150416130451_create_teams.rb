class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.integer :gender, null: false
      t.integer :number, null: false, default: 1

      t.timestamps null: false
    end
  end
end
