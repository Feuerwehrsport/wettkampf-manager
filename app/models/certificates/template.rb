# frozen_string_literal: true

class Certificates::Template < CacheDependendRecord
  mount_uploader :image, Certificates::ImageUploader
  mount_uploader :font, Certificates::FontUploader
  mount_uploader :font2, Certificates::FontUploader
  has_many :text_fields, class_name: 'Certificates::TextField', inverse_of: :template, dependent: :destroy

  accepts_nested_attributes_for :text_fields, allow_destroy: true
  validates :name, presence: true

  def to_json(*_args)
    {
      name: name,
      image: image.present? ? Base64.encode64(image.file.read) : nil,
      image_content_type: image.present? ? image.file.content_type : nil,
      image_name: image.present? ? image.file.filename : nil,
      font: font.present? ? Base64.encode64(font.file.read) : nil,
      font_content_type: font.present? ? font.file.content_type : nil,
      font_name: font.present? ? font.file.filename : nil,
      font2: font2.present? ? Base64.encode64(font2.file.read) : nil,
      font2_content_type: font2.present? ? font2.file.content_type : nil,
      font2_name: font2.present? ? font2.file.filename : nil,
      text_fields: text_fields.map(&:to_export_hash),
    }.to_json
  end
end
