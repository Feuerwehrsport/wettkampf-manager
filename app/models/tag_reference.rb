class TagReference < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates :tag, :taggable, presence: true
end
