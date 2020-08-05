# frozen_string_literal: true

class AddCompetitionResultTypeToCompetition < ActiveRecord::Migration[4.2]
  def change
    add_column :competitions, :competition_result_type, :string
  end
end
