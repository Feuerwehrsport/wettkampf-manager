class Series::AssessmentsController < ApplicationController
  def show
    @assessment = Series::Assessment.find(params[:id]).decorate
    @person_assessments = Series::PersonAssessment.where(round: @assessment.round).where.not(id: @assessment.id).decorate
    @page_title = "#{@assessment.round} #{@assessment} - Wettkampfserie"
  end
end