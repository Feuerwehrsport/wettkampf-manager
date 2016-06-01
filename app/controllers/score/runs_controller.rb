class Score::RunsController < ApplicationController
  implement_crud_actions only: [:edit, :update]

  protected

  def find_resource
    @score_list = Score::List.find(params[:list_id]).decorate
    resource_class.new(list: @score_list, run_number: params[:run])
  end

  def after_save
    redirect_to score_list_path(params[:list_id])
  end

  def score_run_params
    params.require(:score_run).permit(list_entries_attributes: [ :track, :result_type, :second_time ])
  end
end