# frozen_string_literal: true

class AddHostnameToCompetitions < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :hostname, :string, default: '', null: false
  end
end
