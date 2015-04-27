module CRUD::DestroyAction
  extend ActiveSupport::Concern

  included do
    include CRUD::ResourceAssignment
    before_action :assign_resource_for_destroy, only: :destroy
  end

  def destroy
    if destroy_resource
      flash_notice_destroyed
      after_destroy
    else
      flash_error_destroy_failed
      after_destroy_failed
    end
  end


  protected

  def assign_resource_for_destroy
    assign_existing_resource
  end

  def destroy_resource
    resource_instance.destroy
  end

  def after_destroy
    redirect_to action: :index
  end

  def flash_notice_destroyed
    flash[:notice] = t('application.destroy.success', model_name: resource_class.model_name.human)
  end

  def after_destroy_failed
    redirect_to action: :index
  end

  def flash_error_destroy_failed
    Rails.logger.fatal "Cannot destroy resource #{resource_class.name}##{resource_instance.id}"
    flash[:error] = t('application.destroy.error', model_name: resource_class.model_name.human)
  end
end