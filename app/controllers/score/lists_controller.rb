# frozen_string_literal: true

class Score::ListsController < ApplicationController
  implement_crud_actions
  before_action :assign_resource_for_action, only: %i[move select_entity destroy_entity edit_times]
  before_action :assign_tags

  def index
    @list_factory = Score::ListFactory.find_by(session_id: session.id.to_s)
  end

  def show
    super
    page_title @score_list.decorate.to_s
    send_pdf(Exports::PDF::Score::List) do
      [@score_list.decorate, params[:more_columns].present?, params[:double_run].present?]
    end
    send_xlsx(Exports::XLSX::Score::List) { [@score_list.decorate] }
  end

  def edit_times
    authorize!(:edit_times, resource_instance)
  end

  protected

  def after_update_failed
    render(action: params[:edit_times].present? ? :edit_times : :edit)
  end

  def index_collection
    super.decorate.sort_by(&:to_s)
  end

  def assign_tags
    @tags = Tag.all.decorate
  end

  def assign_resource_for_action
    assign_existing_resource
  end

  def score_list_params
    editable_attributes = %i[
      id run track entity_id entity_type _destroy assessment_type assessment_id
    ]

    editable_attributes.push(:result_type, :result_type_before) if can?(:edit_result_types, Score::ListEntry)
    if can?(:edit_times, Score::ListEntry)
      editable_attributes.push(:edit_second_time, :edit_second_time_before,
                               :edit_second_time_left_target, :edit_second_time_left_target_before,
                               :edit_second_time_right_target, :edit_second_time_right_target_before)
    end

    params.require(:score_list).permit(:name, :shortcut, :date, :show_multiple_assessments, :hidden,
                                       result_ids: [],
                                       entries_attributes: editable_attributes,
                                       tag_references_attributes: %i[id tag_id _destroy])
  end
end
