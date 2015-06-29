module Score
  class ListsController < ApplicationController
    implement_crud_actions 
    before_action :assign_resource_for_action, only: [:move, :finished, :select_entity, :destroy_entity, :edit_times]
    before_action :assign_disciplines, only: [:new, :create]

    def assign_disciplines
      @disciplines = Assessment.no_double_event.group(:discipline_id).includes(:discipline).map(&:discipline).map(&:decorate)
    end

    def show
      super
      page_title @score_list.decorate.to_s
    end

    def finished
      @waiting_entries = @score_list.entries.select(&:result_waiting?)
      @unvalid_entries = @score_list.entries.select(&:result_valid?).reject(&:stopwatch_time_valid?)
      @available_time_types = @score_list.available_time_types
      @score_list.result_time_type ||= @available_time_types.first
    end

    def edit_times
    end
  
    protected

    def assign_resource_for_action
      assign_existing_resource
    end

    def score_list_params
      params.require(:score_list).permit(:name, :shortcut, :generator, :track_count, :result_time_type, 
        result_ids: [], assessment_ids: [],
        entries_attributes: [
          :id, :run, :track, :entity_id, :entity_type, :_destroy, :assessment_type, :result_type, :assessment_id,
          time_entries_attributes: [ :second_time ]],
        generator_attributes: [:before_list, :best_count, :result])
    end
  end
end