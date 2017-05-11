class Score::CompetitionResultsController < ApplicationController
  implement_crud_actions only: [:new, :create, :index, :edit, :update, :destroy]

  def index
    super
    page_title 'Gesamtwertung', { page_layout: :landscape }
  end

  protected

  def score_competition_result_params
    params.require(:score_competition_result).permit(:name, :gender, :result_type, assessment_ids: [])
  end

  def after_save
    redirect_to action: :index
  end
end
