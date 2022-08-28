class AddCalculationMethodToScoreResults < ActiveRecord::Migration[5.2]
  def change
    add_column :score_results, :calculation_method, :integer, default: 0, null: false
  end
end
