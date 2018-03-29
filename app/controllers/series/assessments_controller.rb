class Series::AssessmentsController < ApplicationController
  decorates_assigned :assessment, :person_assessments

  def show
    @assessment = Series::Assessment.find(params[:id])
    @person_assessments = Series::PersonAssessment.where(round: @assessment.round).where.not(id: @assessment.id)
    @page_title = "#{@assessment.round} #{@assessment} - Wettkampfserie"
  end
end
