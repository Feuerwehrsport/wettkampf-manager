class Score::ListsController < ApplicationController
  implement_crud_actions 
  before_action :assign_resource_for_action, only: [:move, :select_entity, :destroy_entity, :edit_times]
  before_action :assign_tags

  def index
    @list_factory = Score::ListFactory.find_by_session_id(session.id)
  end

  def show
    super
    page_title @score_list.decorate.to_s
  end

  def edit_times
  end

  protected

  def assign_tags
    @tags = Tag.all.decorate
  end

  def assign_resource_for_action
    assign_existing_resource
  end

  def score_list_params
    params.require(:score_list).permit(:name, :shortcut,
      entries_attributes: [
        :id, :run, :track, :entity_id, :entity_type, :_destroy, :assessment_type, 
        :result_type, :assessment_id, :edit_second_time
      ],
      tag_references_attributes: [:id, :tag_id, :_destroy]
    )
  end
end