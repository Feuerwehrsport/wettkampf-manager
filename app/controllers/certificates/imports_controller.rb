# frozen_string_literal: true

class Certificates::ImportsController < ApplicationController
  implement_crud_actions only: %i[new create]

  protected

  def certificates_import_params
    params.require(:certificates_import).permit(:file)
  end

  def after_save
    redirect_to certificates_template_path(resource_instance.template)
  end
end
