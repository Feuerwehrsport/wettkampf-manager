# frozen_string_literal: true

class PeopleController < ApplicationController
  implement_crud_actions
  before_action :assign_resource_for_action, only: %i[edit_assessment_requests statistic_suggestions]

  def edit_assessment_requests; end

  def index
    super
    @without_statistics_id = @people.where(fire_sport_statistics_person_id: nil)
    page_title 'Wettkämpfer'

    send_pdf(Exports::PDF::People) { [@people] }
    send_xlsx(Exports::XLSX::People) { [@people] }
  end

  def without_statistics_id
    @person_suggestions = base_collection.where(fire_sport_statistics_person_id: nil).map do |person|
      FireSportStatistics::PersonSuggestion.new(person).decorate
    end
  end

  def statistic_suggestions; end

  protected

  def assign_resource_for_action
    assign_existing_resource
  end

  def after_create
    render 'edit_assessment_requests'
  end

  def build_resource
    instance = super
    instance.assign_attributes(team: team_from_param, band: team_from_param.band) if team_from_param.present?
    instance.band ||= Band.find(params[:band_id])
    instance
  end

  def team_from_param
    @team_from_param ||= Team.find_by(id: params[:team])
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :team_id, :band_id, :fire_sport_statistics_person_id,
                                   :registration_order, :bib_number, :create_team_name,
                                   requests_attributes: %i[assessment_type _destroy assessment_id id
                                                           group_competitor_order single_competitor_order
                                                           competitor_order],
                                   tag_references_attributes: %i[id tag_id _destroy])
  end
end
