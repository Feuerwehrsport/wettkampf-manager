class AssessmentsController < ApplicationController
  implement_crud_actions
  before_action :assign_resource_for_action, only: [:possible_associations]
  before_action :assign_tags

  def possible_associations
    render json: { results: @assessment.results.pluck(:id), lists: @assessment.lists.pluck(:id) }
  end

  protected

  def assign_resource_for_action
    assign_existing_resource
  end

  def assign_tags
    @tags = Tag.all.decorate
  end

  def assessment_params
    params.require(:assessment).permit(:name, :discipline_id, :gender,
                                       tag_references_attributes: %i[id tag_id _destroy])
  end
end
