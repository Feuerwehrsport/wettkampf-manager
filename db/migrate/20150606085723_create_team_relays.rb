class CreateTeamRelays < ActiveRecord::Migration
  def change
    create_table :team_relays do |t|
      t.references :team, index: true, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
