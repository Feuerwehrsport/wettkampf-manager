# frozen_string_literal: true

class Imports::ConfigurationsController < ApplicationController
  before_action :redirect_to_root, only: %i[new create show edit update destroy]
  before_action :redirect_to_edit, only: %i[new create show]
  implement_crud_actions only: %i[new create show edit update destroy]

  def index
    redirect_to action: :new
  end

  protected

  def after_create
    redirect_to action: :edit, id: resource_instance.id
  end

  def imports_configuration_params
    params.require(:imports_configuration).permit(:file, :execute)
  end

  def redirect_to_root
    return unless resource_class.exists?
    return if resource_class.first.executed_at.blank?

    flash[:notice] = 'Import wurde durchgeführt'
    redirect_to(root_path)
  end

  def redirect_to_edit
    return unless resource_class.exists?

    redirect_to action: :edit, id: resource_class.first.id
  end
end
