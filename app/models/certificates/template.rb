class Certificates::Template < CacheDependendRecord
  mount_uploader :image, Certificates::ImageUploader
  mount_uploader :font, Certificates::FontUploader
  has_many :text_fields, class_name: 'Certificates::TextField', inverse_of: :template, dependent: :destroy

  accepts_nested_attributes_for :text_fields, allow_destroy: true
  validates :name, presence: true
end
