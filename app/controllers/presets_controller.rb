# frozen_string_literal: true

class PresetsController < ApplicationController
  implement_crud_actions only: %i[show index update]
  before_action do
    redirect_to(root_path) if Competition.one.configured?
    redirect_to(login_path) unless logged_in?
  end

  protected

  def update_resource
    resource_instance.save
  end

  def flash_notice_updated
    flash[:notice] = 'Vorgang erfolgreich durchgeführt'
  end

  def preset_params
    {}
  end

  def find_resource
    resource_class.find(params[resource_param_id])
  end
end
