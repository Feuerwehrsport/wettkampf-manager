# frozen_string_literal: true

class Score::RunsController < ApplicationController
  implement_crud_actions only: %i[edit update]

  protected

  def find_resource
    @score_list = Score::List.find(params[:list_id]).decorate
    resource_class.new(list: @score_list, run_number: params[:run])
  end

  def after_save
    redirect_to score_list_path(params[:list_id], anchor: "jump-run-#{params[:run]}")
  end

  def score_run_params
    params.require(:score_run).permit(list_entries_attributes:
      %i[id track last_update_timestamp result_type edit_second_time
         edit_second_time_left_target edit_second_time_right_target])
  end
end
