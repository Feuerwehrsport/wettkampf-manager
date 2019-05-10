class TeamsController < ApplicationController
  implement_crud_actions
  before_action :assign_team_tags
  before_action :assign_resource_for_edit_assessment_requests, only: %i[edit_assessment_requests statistic_suggestions]

  def show
    super
    @person_tags = PersonTag.all.decorate
  end

  def index
    super
    @without_statistics_id = @teams.where(fire_sport_statistics_team_id: nil)
    default_meta_description title: 'Mannschaften'

    send_pdf(PDF::Teams::Index, args: [@teams.decorate])
  end

  def edit_assessment_requests; end

  def without_statistics_id
    @team_suggestions = base_collection.where(fire_sport_statistics_team_id: nil).map do |team|
      FireSportStatistics::TeamSuggestion.new(team).decorate
    end
  end

  def statistic_suggestions; end

  protected

  def assign_team_tags
    @tags = TeamTag.all.decorate
  end

  def assign_resource_for_edit_assessment_requests
    assign_existing_resource
  end

  def team_params
    params.require(:team).permit(
      :name, :gender, :number, :shortcut, :fire_sport_statistics_team_id, :lottery_number, :federal_state_id,
      requests_attributes: %i[assessment_type relay_count _destroy assessment_id id],
      tag_references_attributes: %i[id tag_id _destroy]
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
