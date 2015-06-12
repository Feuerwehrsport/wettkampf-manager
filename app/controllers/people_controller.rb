class PeopleController < ApplicationController
  implement_crud_actions
  before_action :assign_resource_for_edit_assessment_requests, only: :edit_assessment_requests

  def edit_assessment_requests
  end

  def index
    super
    @female = @people.female.decorate
    @male = @people.male.decorate
  end

  protected

  def assign_resource_for_edit_assessment_requests
    assign_existing_resource
  end

  def after_create
    render 'edit_assessment_requests'
  end

  def build_resource
    instance = super
    instance.assign_attributes(team: team_from_param, gender: team_from_param.gender) if team_from_param.present?
    instance
  end

  def team_from_param
    @team_from_param ||= Team.find_by_id(params[:team])
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :team_id, :gender, :youth,
      { requests_attributes: [:assessment_type, :_destroy, :assessment_id, :id, :group_competitor_order, :single_competitor_order] })
  end
end
