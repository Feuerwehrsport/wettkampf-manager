class Imports::ConfigurationsController < ApplicationController
  before_action :redirect_to_show, only: %i[new create]
  before_action :redirect_to_new, only: %i[show edit update destroy]
  implement_crud_actions only: %i[new create show edit update destroy]

  def index
    redirect_to action: :new
  end

  protected

  def after_create
    redirect_to action: :edit, id: resource_instance.id
  end

  def imports_configuration_params
    params.require(:imports_configuration).permit(:file, :execute,
                                                  tags_attributes: %i[id use],
                                                  assessments_attributes: %i[id assessment_id])
  end

  def redirect_to_show
    redirect_to resource_class.first unless resource_class.possible?
  end

  def redirect_to_new
    return if resource_class.first.executed_at.blank?
    flash[:notice] = 'Import wurde durchgeführt'
    redirect_to(root_path)
  end
end
