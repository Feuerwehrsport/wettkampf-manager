module Series
  class AssessmentsController < ApplicationController
    def show
      @assessment = Assessment.find(params[:id]).decorate
      @person_assessments = PersonAssessment.where(round: @assessment.round).where.not(id: @assessment.id).decorate
      @page_title = "#{@assessment.round} #{@assessment} - Wettkampfserie"
    end
  end
end