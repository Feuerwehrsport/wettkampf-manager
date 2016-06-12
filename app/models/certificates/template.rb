class Certificates::Template < CacheDependendRecord
  mount_uploader :image, Certificates::ImageUploader
  mount_uploader :font, Certificates::FontUploader
  has_many :text_positions, dependent: :destroy

  accepts_nested_attributes_for :text_positions, allow_destroy: true
  validates :name, presence: true
end
