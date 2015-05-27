class AddGroupCompetitorOrderToAssessmentRequest < ActiveRecord::Migration
  def change
    add_column :assessment_requests, :group_competitor_order, :integer, default: 0, null: false
  end
end
