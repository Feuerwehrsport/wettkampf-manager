module Score
  class ResultsController < ApplicationController
    implement_crud_actions 

    protected

    def score_result_params
      params.require(:score_result).permit(:name, :assessment_id, :group_assessment)
    end
  end
end
