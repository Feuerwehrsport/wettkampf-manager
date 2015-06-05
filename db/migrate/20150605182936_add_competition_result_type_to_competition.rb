class AddCompetitionResultTypeToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :competition_result_type, :string
  end
end
