module Taggable
  extend ActiveSupport::Concern
  included do
    has_many :tag_references, as: :taggable, dependent: :destroy, inverse_of: :taggable
    has_many :tags, through: :tag_references
    accepts_nested_attributes_for :tag_references, reject_if: :all_blank, allow_destroy: true
  end

  def tag_names
    tags.map(&:name)
  end

  def include_tags?(other_tags)
    other_tags.all? { |tag| tags.include?(tag) }
  end
end