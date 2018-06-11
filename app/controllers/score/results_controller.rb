class Score::ResultsController < ApplicationController
  implement_crud_actions

  before_action :assign_tags

  def show
    super
    @rows = @score_result.rows.map(&:decorate)
    @out_of_competition_rows = @score_result.out_of_competition_rows.map(&:decorate)
    @discipline = @score_result.assessment.discipline.decorate
    if @score_result.group_assessment? && @discipline.single_discipline?
      @group_result_rows = Score::GroupResult.new(@score_result).rows.map(&:decorate)
    end
    page_title @score_result.decorate.to_s
    @only = params[:only].try(:to_sym)
  end

  def edit
    @series_form = params[:series].present?
    super
  end

  protected

  def index_collection
    super.decorate.sort_by(&:to_s)
  end

  def assign_tags
    @tags = Tag.all.decorate
  end

  def score_result_params
    params.require(:score_result).permit(:name, :assessment_id, :group_assessment, :date,
                                         series_assessment_ids: [],
                                         tag_references_attributes: %i[id tag_id _destroy])
  end
end
