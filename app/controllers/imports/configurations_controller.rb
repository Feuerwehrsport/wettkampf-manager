module Imports
  class ConfigurationsController < ApplicationController
    before_action :redirect_to_show, only: [:new, :create]
    before_action :redirect_to_new, only: [:show, :edit, :update, :destroy]
    implement_crud_actions only: [:new, :create, :show, :edit, :update, :destroy]

    def index
      redirect_to action: :new
    end

    protected

    def imports_configuration_params
      params.require(:imports_configuration).permit(:file, :execute,
        tags_attributes: [:id, :use], 
        assessments_attributes: [:id, :assessment_id]
      )
    end

    def redirect_to_show
      redirect_to resource_class.first unless resource_class.possible?
    end

    def redirect_to_new
      if resource_class.possible?
        redirect_to(action: :new)
      else
        if resource_class.first.executed_at.present?
          flash[:notice] = "Import wurde durchgeführt"
          redirect_to(root_path)
        end
      end
    end
  end
end