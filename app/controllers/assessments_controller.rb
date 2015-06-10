class AssessmentsController < ApplicationController
  implement_crud_actions 
  before_action :assign_resource_for_action, only: [:possible_associations]

  def possible_associations
    render json: { results: @assessment.results.pluck(:id), lists: @assessment.lists.pluck(:id) }
  end

  protected

  def assign_resource_for_action
    assign_existing_resource
  end

  def assessment_params
    params.require(:assessment).permit(:name, :discipline_id, :gender)
  end
end
