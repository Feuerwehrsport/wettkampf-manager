# frozen_string_literal: true

class AddUniqueIndexOnTeams < ActiveRecord::Migration[5.2]
  def change
    add_index :teams, %i[name number gender], unique: true
  end
end
