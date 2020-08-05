# frozen_string_literal: true

class AddLotteryToCompetitions < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :lottery_numbers, :boolean, null: false, default: false
    add_column :teams, :lottery_number, :integer
  end
end
