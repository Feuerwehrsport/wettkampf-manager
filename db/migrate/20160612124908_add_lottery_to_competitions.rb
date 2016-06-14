class AddLotteryToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :lottery_numbers, :boolean, null: false, default: false
    add_column :teams, :lottery_number, :integer
  end
end
