module CRUD::EditAction
  extend ActiveSupport::Concern

  included do
    include CRUD::ResourceAssignment
    before_action :assign_resource_for_edit, only: :edit
  end

  def edit; end

  protected

  def assign_resource_for_edit
    assign_existing_resource
  end
end
