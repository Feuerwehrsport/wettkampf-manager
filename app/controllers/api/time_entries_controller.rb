class API::TimeEntriesController < ApplicationController
  implement_crud_actions only: [:create, :index, :show, :edit, :update]
  before_action :skip_closed_entries, only: [:show, :edit, :update]
  before_action :assign_list_entry, only: [:edit, :update]
  skip_before_action :verify_authenticity_token, only: :create

  def show
    super
    @lists = []
    Score::List.where(id: Score::ListEntry.waiting.group(:list_id).select(:list_id)).each do |list|
      @lists.push(list.decorate)
    end
  end

  def index
    @waiting_time_entries = @api_time_entries.waiting.decorate
    @closed_time_entries = @api_time_entries.closed.decorate
  end

  def ignore
    assign_existing_resource
    skip_closed_entries
    resource_instance.update_attributes(used_at: Time.now)
    redirect_to action: :index
  end

  protected

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
  end

  def skip_closed_entries
    redirect_to(action: :index) if @api_time_entry.used_at.present?
  end

  def api_time_entry_params
    if action_name == 'create'
      params.require(:api_time_entry).permit(:time, :hint, :password, :sender)
    else
      params.require(:api_time_entry).permit(score_list_entry_attributes: [:id, :edit_second_time, :result_type])
    end
  end
end
