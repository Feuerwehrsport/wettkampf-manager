class Score::CompetitionResultsController < ApplicationController
  implement_crud_actions only: %i[new create index edit update destroy]

  def index
    super
    page_title 'Gesamtwertung'

    send_pdf(Exports::PDF::Score::CompetitionResults) { [@score_competition_results.decorate] }
    send_xlsx(Exports::XLSX::Score::CompetitionResults) { [@score_competition_results.decorate] }
  end

  protected

  def score_competition_result_params
    params.require(:score_competition_result).permit(:name, :gender, :result_type, assessment_ids: [])
  end

  def after_save
    redirect_to action: :index
  end
end
