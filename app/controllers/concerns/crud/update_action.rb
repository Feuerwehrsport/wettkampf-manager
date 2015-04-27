module CRUD::UpdateAction
  extend ActiveSupport::Concern

  included do
    include CRUD::ResourceAssignment
    include CRUD::AfterSaveHandler
    include CRUD::ResourceParams
    before_action :assign_resource_for_update, only: :update
  end

  def update
    if update_resource
      flash_notice_updated
      after_update
    else
      after_update_failed
    end
  end


  protected

  def assign_resource_for_update
    assign_existing_resource
  end

  def update_resource
    resource_instance.update_attributes(resource_params)
  end

  def after_update
    after_save
  end

  def after_update_failed
    render action: :edit
  end

  def flash_notice_updated
    flash[:notice] = t('application.update.success', model_name: resource_class.model_name.human)
  end
end