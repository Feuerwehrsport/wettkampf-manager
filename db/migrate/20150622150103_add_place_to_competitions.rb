# frozen_string_literal: true

class AddPlaceToCompetitions < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :place, :string, null: false, default: ''
  end
end
