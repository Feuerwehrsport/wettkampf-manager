class Series::RoundsController < ApplicationController
  def index
    @rounds = Series::Round.with_local_results.distinct
    redirect_to @rounds.first if @rounds.count == 1
  end

  def show
    round = Series::Round.find(params[:id])
    @person_assessments = Series::PersonAssessment.where(round: round)
    @team_assessments_exists = Series::TeamAssessment.where(round: round).present?
    @round = round.decorate
    @page_title = "#{@round} - Wettkampfserie"
  end
end
