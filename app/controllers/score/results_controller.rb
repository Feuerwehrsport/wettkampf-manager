module Score
  class ResultsController < ApplicationController
    implement_crud_actions

    def show
      super
      @rows = @score_result.rows.map(&:decorate)
      @group_result_rows = GroupResult.new(@score_result).rows.map(&:decorate)
    end

    protected

    def score_result_params
      params.require(:score_result).permit(:name, :assessment_id, :group_assessment)
    end
  end
end
