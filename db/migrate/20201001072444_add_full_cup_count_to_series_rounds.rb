class AddFullCupCountToSeriesRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :series_rounds, :full_cup_count, :integer, default: 4, null: false
  end
end
