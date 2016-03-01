class Tag < ActiveRecord::Base
  belongs_to :competition
  has_many :tag_references, dependent: :destroy

  validates :name, :competition, presence: true
end
