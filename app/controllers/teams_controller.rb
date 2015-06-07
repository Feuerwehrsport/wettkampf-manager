class TeamsController < ApplicationController
  implement_crud_actions
  before_action :assign_resource_for_edit_assessment_requests, only: :edit_assessment_requests

  def edit_assessment_requests
  end

  protected

  def assign_resource_for_edit_assessment_requests
    assign_existing_resource
  end

  def team_params
    params.require(:team).permit(:name, :gender, :number, 
      { requests_attributes: [:assessment_type, :relay_count, :_destroy, :assessment_id, :id] })
  end
end
