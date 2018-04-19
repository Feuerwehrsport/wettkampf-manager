class Certificates::ListsController < ApplicationController
  implement_crud_actions
  before_action :assign_resource_for_export, only: :export

  def export
    if create_resource
      @certificates_template = @certificates_list.template
      @score_result = @certificates_list.result.decorate
      @rows = @score_result.rows.map(&:decorate)
      page_title('Urkunde', margin: [0, 0, 0, 0])
    else
      after_create_failed
    end
  end

  protected

  def certificates_list_params
    params.require(:certificates_list).permit(:template_id, :image, :score_result_id, :competition_result_id)
  end

  def build_resource
    resource_class.new(score_result_id: params[:score_result_id], competition_result_id: params[:competition_result_id])
  end

  def after_create; end

  def assign_resource_for_export
    assign_new_resource
  end
end
