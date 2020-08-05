# frozen_string_literal: true

class AddSingleCompetitorOrderToAssessmentRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :assessment_requests, :single_competitor_order, :integer, default: 0, null: false
  end
end
