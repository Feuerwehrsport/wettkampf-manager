module CRUD::AuthorizeAction

  extend ActiveSupport::Concern

  def index
    authorize!(:index, resource_class)
    super
  end

  protected

  def base_collection
    super.accessible_by(current_ability, :index)
  end

  def assign_new_resource
    super
    authorize!(:new, resource_instance)
    resource_instance
  end

  def assign_resource_for_update
    super
    authorize!(:update, resource_instance)
    resource_instance
  end

  def assign_resource_for_show
    super
    authorize!(:show, resource_instance)
    resource_instance
  end

  def assign_resource_for_edit
    super
    authorize!(:edit, resource_instance)
    resource_instance
  end

  def assign_resource_for_destroy
    super
    authorize!(:destroy, resource_instance)
    resource_instance
  end

end