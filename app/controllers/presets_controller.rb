class PresetsController < ApplicationController
  implement_crud_actions only: [:show, :index, :update]
  before_action do
    redirect_to(root_path) if Competition.one.configured?
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
