module Score
  class ResultsController < ApplicationController
    implement_crud_actions

    def show
      super
      @rows = @score_result.rows.map(&:decorate)
      @discipline = @score_result.assessment.discipline.decorate
      if @score_result.group_assessment? && @discipline.single_discipline?
        @group_result_rows = GroupResult.new(@score_result).rows.map(&:decorate)
      end
      page_title @score_result.decorate.to_s
    end

    protected

    def score_result_params
      params.require(:score_result).permit(:name, :assessment_id, :group_assessment, :youth)
    end
  end
end
