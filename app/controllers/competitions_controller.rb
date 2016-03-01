class CompetitionsController < ApplicationController
  implement_crud_actions only: [:show, :edit, :update]

  protected

  def competition_params
    params.require(:competition).permit(:name, :date, :group_people_count, :group_run_count, :group_score_count, 
      :youth_name, :hostname, :competition_result_type, :d_cup, :place, :show_bib_numbers,
      person_tags_attributes: [:id, :name, :_destroy],
      team_tags_attributes: [:id, :name, :_destroy])
  end
end
