# frozen_string_literal: true

module CRUD::IndexAction
  extend ActiveSupport::Concern

  included do
    include CRUD::ResourceAssignment
    before_action :assign_resource_for_index, only: :index
  end

  def index
    self.collection_instance = collection_instance.index_order if collection_instance.respond_to?(:index_order)
    scope_index_collection
  end

  protected

  def scope_index_collection
    self.collection_instance = default_index_scope
  end

  def default_index_scope
    collection_instance
  end

  def assign_resource_for_index
    self.collection_instance = index_collection
  end

  def index_collection
    collection = base_collection
    collection = collection.search(params[:search]) if resource_class.respond_to?(:search) && params[:search].present?
    collection
  end
end
