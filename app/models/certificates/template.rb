class Certificates::Template < CacheDependendRecord
  mount_uploader :image, Certificates::ImageUploader
  mount_uploader :font, Certificates::FontUploader
  has_many :text_fields, class_name: 'Certificates::TextField', inverse_of: :template, dependent: :destroy

  accepts_nested_attributes_for :text_fields, allow_destroy: true
  validates :name, presence: true

  def to_json
    {
      name: name,
      image: image.present? ? Base64.encode64(image.file.read) : nil,
      image_content_type: image.present? ? image.file.content_type : nil,
      image_name: image.present? ? image.file.filename : nil,
      font: font.present? ? Base64.encode64(font.file.read) : nil,
      font_content_type: font.present? ? font.file.content_type : nil,
      font_name: font.present? ? font.file.filename : nil,
      text_fields: text_fields.map(&:to_export_hash),
    }.to_json
  end
end
