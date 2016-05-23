module Score
  class ListFactoriesController < ApplicationController
    implement_crud_actions
    before_action :redirect_to_edit, only: [:new, :create]
    before_action :assign_disciplines, only: :new

    protected

    def assign_disciplines
      @factories = Assessment.no_double_event.group(:discipline_id).includes(:discipline).map(&:discipline).map do |discipline|
        resource_class.new(discipline: discipline.decorate)
      end
    end

    def redirect_to_edit
      redirect_to action: :edit if base_collection.find_by_session_id(session.id).present?
    end

    def after_save
      if @score_list_factory.status == :create
        @score_list_factory.destroy
        redirect_to @score_list_factory.list
      else
        redirect_to action: :edit
      end
    end

    def find_resource
      base_collection.find_by_session_id!(session.id)
    end

    def build_resource
      resource_class.new(session_id: session.id)
    end

    def flash_notice_created
    end

    def after_destroy
      redirect_to action: :index, controller: 'score/lists'
    end

    def flash_notice_destroyed
    end

    def flash_notice_updated
    end

    def score_list_factory_params
      params.require(:score_list_factory).permit(:discipline_id, :next_step, :name, :shortcut, :track_count, 
        :type, :before_result_id, :before_list_id, :best_count,
        result_ids: [], assessment_ids: [])
    end
  end
end