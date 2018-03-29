module CRUD::NewAction
  extend ActiveSupport::Concern

  included do
    include CRUD::ResourceAssignment
    before_action :assign_resource_for_new, only: :new
  end

  def new; end

  protected

  def assign_resource_for_new
    assign_new_resource
  end
end
