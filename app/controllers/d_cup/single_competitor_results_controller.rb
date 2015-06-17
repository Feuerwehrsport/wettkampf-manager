module DCup
  class SingleCompetitorResultsController < ApplicationController
    def index
      @results = resource_class.all.map(&:decorate)
    end

    def show
      @result = resource_class.find(params[:id]).decorate
    end
  end
end
