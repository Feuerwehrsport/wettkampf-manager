class Teams::ImportsController < ApplicationController
  implement_crud_actions only: %i[new create]

  protected

  def after_create
    redirect_to teams_path
  end

  def flash_notice_created
    flash[:notice] = "#{resource_instance.teams.count} Mannschaften wurden angelegt"
  end

  def teams_import_params
    params.require(:teams_import).permit(
      :import_rows, :gender
    )
  end
end
