# frozen_string_literal: true

module CRUD::AfterSaveHandler
  extend ActiveSupport::Concern

  protected

  def after_save
    redirect_to action: :show, id: resource_instance.id
  end
end
