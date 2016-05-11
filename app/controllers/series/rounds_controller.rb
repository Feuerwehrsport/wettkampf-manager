module Series
  class RoundsController < ApplicationController
    def index
      @rounds = Series::Round.with_local_results.uniq
      redirect_to @rounds.first if @rounds.count == 1
    end

    def show
      round = Round.find(params[:id])
      @person_assessments = PersonAssessment.where(round: round)
      @team_assessments_exists = TeamAssessment.where(round: round).present?
      @round = round.decorate
      @page_title = "#{@round} - Wettkampfserie"
    end
  end
end