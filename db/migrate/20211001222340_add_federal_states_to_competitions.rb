class AddFederalStatesToCompetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :competitions, :federal_states, :boolean, null: false, default: false
  end
end
