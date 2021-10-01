# frozen_string_literal: true

class CompetitionsController < ApplicationController
  implement_crud_actions only: %i[show edit update]

  protected

  def find_resource
    base_collection.first
  end

  def competition_params
    params.require(:competition).permit(:name, :date, :group_people_count, :group_run_count, :group_score_count,
                                        :hostname, :competition_result_type, :place, :show_bib_numbers,
                                        :flyer_headline, :flyer_text, :backup_path, :lottery_numbers,
                                        :hide_competition_results, :federal_states,
                                        person_tags_attributes: %i[id name _destroy],
                                        team_tags_attributes: %i[id name _destroy])
  end
end
