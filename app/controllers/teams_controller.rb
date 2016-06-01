class TeamsController < ApplicationController
  implement_crud_actions
  before_action :assign_team_tags
  before_action :assign_resource_for_edit_assessment_requests, only: :edit_assessment_requests

  def show
    super
    @person_tags = PersonTag.all.decorate
  end

  def index
    super
    page_title 'Mannschaften'
  end

  def edit_assessment_requests
  end

  protected

  def assign_team_tags
    @tags = TeamTag.all.decorate
  end

  def assign_resource_for_edit_assessment_requests
    assign_existing_resource
  end

  def team_params
    params.require(:team).permit(:name, :gender, :number, :shortcut,
      requests_attributes: [:assessment_type, :relay_count, :_destroy, :assessment_id, :id],
      tag_references_attributes: [:id, :tag_id, :_destroy]
    )
  end

  def after_create
    if single_discipline_exists?
      super
    else
      redirect_to action: :index
    end
  end

  def single_discipline_exists?
    Discipline.all.any?(&:single_discipline?)
  end
end
