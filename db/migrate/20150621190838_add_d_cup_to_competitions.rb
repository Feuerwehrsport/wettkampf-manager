class AddDCupToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :d_cup, :boolean, null: false, default: false
  end
end
