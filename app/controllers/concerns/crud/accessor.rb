module CRUD::Accessor
  extend ActiveSupport::Concern

  protected

  class_methods do
    def implement_crud_actions(options = {})
      only = options[:only]
      only ||= [:index, :new, :create, :show, :edit, :update, :destroy]
      only = [only].flatten
      include CRUD::IndexAction if only.include?(:index)
      include CRUD::NewAction if only.include?(:new)
      include CRUD::CreateAction if only.include?(:create)
      include CRUD::ShowAction if only.include?(:show)
      include CRUD::EditAction if only.include?(:edit)
      include CRUD::UpdateAction if only.include?(:update)
      include CRUD::DestroyAction if only.include?(:destroy)
    end
  end
end