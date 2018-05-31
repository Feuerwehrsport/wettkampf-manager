class Score::ListFactoriesController < ApplicationController
  implement_crud_actions
  before_action :redirect_to_edit, only: %i[new create]
  before_action :assign_disciplines, only: :new

  def copy_list
    list = Score::List.find(params[:list_id])
    base_collection.where(session_id: session.id).destroy_all

    factory = Score::ListFactories::TrackChange.create!(
      session_id: session.id,
      discipline_id: list.assessments.first.discipline_id,
      next_step: :assessments,
    )
    factory.update!(assessments: list.assessments, next_step: :names)
    factory.update!(next_step: :tracks, name: factory.default_name, shortcut: factory.default_shortcut)
    factory.update!(next_step: :results, track_count: list.track_count)
    factory.update!(next_step: :generator, results: list.results)

    redirect_to action: :edit
  end

  protected

  def assign_disciplines
    @factories = Assessment.no_double_event.group(:discipline_id).includes(:discipline)
                           .map(&:discipline).map do |discipline|
      resource_class.new(discipline: discipline.decorate)
    end
  end

  def redirect_to_edit
    redirect_to action: :edit if base_collection.find_by(session_id: session.id).present?
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
    base_collection.find_by!(session_id: session.id)
  end

  def build_resource
    resource_class.new(session_id: session.id)
  end

  def flash_notice_created; end

  def after_destroy
    redirect_to action: :index, controller: 'score/lists'
  end

  def flash_notice_destroyed; end

  def flash_notice_updated; end

  def score_list_factory_params
    params.require(:score_list_factory).permit(:discipline_id, :next_step, :name, :shortcut, :track_count,
                                               :type, :before_result_id, :before_list_id, :best_count, :track, :gender,
                                               result_ids: [], assessment_ids: [])
  end
end
