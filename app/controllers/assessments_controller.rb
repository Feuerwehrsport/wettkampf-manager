# frozen_string_literal: true

class AssessmentsController < ApplicationController
  implement_crud_actions
  before_action :assign_tags, only: %i[new create edit update]

  protected

  def index_collection
    super.decorate.sort_by(&:to_s)
  end

  def assign_tags
    @tags = Tag.all.decorate
  end

  def assessment_params
    params.require(:assessment).permit(:name, :discipline_id, :band_id,
                                       tag_references_attributes: %i[id tag_id _destroy])
  end
end
