# frozen_string_literal: true

class API::TimeEntriesController < ApplicationController
  implement_crud_actions only: %i[create index show edit update]
  before_action :skip_closed_entries, only: %i[show edit update]
  before_action :assign_list_entry, only: %i[edit update]
  skip_before_action :verify_authenticity_token, only: :create

  def show
    super
    @lists = open_lists
  end

  def index
    super
    limit = params[:all].present? ? nil : 30
    @waiting_time_entries = @api_time_entries.waiting.decorate
    @closed_time_entries = @api_time_entries.closed.limit(limit).decorate
    @lists = open_lists
  end

  def ignore
    assign_existing_resource
    skip_closed_entries
    resource_instance.update(used_at: Time.current)
    redirect_to action: :index
  end

  protected

  def open_lists
    Score::List.where(id: Score::ListEntry.waiting.group(:list_id).select(:list_id)).map(&:decorate)
  end

  def after_create
    render json: { success: true }
  end

  def after_create_failed
    render json: { success: false, error: resource_instance.errors }
  end

  def after_update
    if resource_class.next_waiting_entry
      redirect_to action: :show, id: resource_class.next_waiting_entry.id, anchor: "list-#{@list_entry.list_id}"
    else
      redirect_to action: :index
    end
  end

  def assign_list_entry
    @api_time_entry.score_list_entry = Score::ListEntry.waiting.find(params[:score_list_entry_id])
    @list_entry = @api_time_entry.score_list_entry
    @score_list = @list_entry.list
  end

  def skip_closed_entries
    redirect_to(action: :index) if @api_time_entry.used_at.present?
  end

  def api_time_entry_params
    if action_name == 'create'
      params.require(:api_time_entry).permit(:time, :hint, :password, :sender)
    else
      params.require(:api_time_entry).permit(score_list_entry_attributes: %i[id edit_second_time result_type])
    end
  end
end
