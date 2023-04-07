# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def self.collection_decorator_class
    ApplicationCollectionDecorator
  end
end
