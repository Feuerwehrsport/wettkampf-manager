class AddRelayCountToAssessmentRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :assessment_requests, :relay_count, :integer, default: 1, null: false
  end
end
