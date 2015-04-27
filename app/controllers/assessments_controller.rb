class AssessmentsController < ApplicationController
  implement_crud_actions 

  protected

  def assessment_params
    params.require(:assessment).permit(:name, :discipline_id, :gender)
  end
end
