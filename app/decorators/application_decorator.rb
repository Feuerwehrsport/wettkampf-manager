class ApplicationDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def self.collection_decorator_class
    ApplicationCollectionDecorator
  end

  def translated_gender
    t("gender.#{gender}")
  end

  def gender_symbol
    t("gender.#{gender}_symbol")
  end
end
