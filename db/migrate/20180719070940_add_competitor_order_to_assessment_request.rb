class AddCompetitorOrderToAssessmentRequest < ActiveRecord::Migration
  def change
    add_column :assessment_requests, :competitor_order, :integer, default: 0, null: false
  end
end
