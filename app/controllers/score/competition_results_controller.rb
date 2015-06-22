module Score
  class CompetitionResultsController < ApplicationController
    implement_crud_actions only: [:index]

    def index
      super
      page_title "Gesamtwertung"
    end

    def new
      super
      dcup = @score_competition_result.dcup
      @female = dcup.first.map(&:decorate)
      @male = dcup.last.map(&:decorate)
    end
  end
end
