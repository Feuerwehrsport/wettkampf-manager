# frozen_string_literal: true

module CRUD::CreateAction
  extend ActiveSupport::Concern

  included do
    include CRUD::ResourceAssignment
    include CRUD::AfterSaveHandler
    include CRUD::ResourceParams
    before_action :assign_resource_for_create, only: :create
  end

  def create
    if create_resource
      flash_notice_created
      after_create
    else
      after_create_failed
    end
  end

  protected

  def assign_resource_for_create
    assign_new_resource
  end

  def create_resource
    resource_instance.assign_attributes(resource_params)
    resource_instance.save
  end

  def after_create
    after_save
  end

  def flash_notice_created
    flash[:notice] = t('application.create.success', model_name: resource_class.model_name.human)
  end

  def after_create_failed
    render action: :new
  end
end
