class AddYouthNameToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :youth_name, :string, null: false, default: ""
  end
end
