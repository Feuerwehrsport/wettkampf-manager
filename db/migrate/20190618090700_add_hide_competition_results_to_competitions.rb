# frozen_string_literal: true

class AddHideCompetitionResultsToCompetitions < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :hide_competition_results, :boolean, default: false, null: false
  end
end
