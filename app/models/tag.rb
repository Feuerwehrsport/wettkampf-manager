# frozen_string_literal: true

class Tag < CacheDependendRecord
  belongs_to :competition
  has_many :tag_references, dependent: :destroy

  validates :name, :competition, presence: true
end
