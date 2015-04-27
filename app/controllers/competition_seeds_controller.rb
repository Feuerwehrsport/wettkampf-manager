class CompetitionSeedsController < ApplicationController
  implement_crud_actions only: [:show]
  before_action :assign_resource_for_execute, only: :execute

  def execute
    begin
      @competition_seed.execute
      flash[:success] = "Vorgang erfolgreich durchgeführt"
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "Vorgang konnte nicht durchgeführt werden: #{e.message}"
    end
    redirect_to root_path
  end

  protected

  def assign_resource_for_execute
    assign_existing_resource
  end

  def find_resource
    resource_class.find(params[resource_param_id])
  end
end
