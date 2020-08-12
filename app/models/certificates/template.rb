# frozen_string_literal: true

class Certificates::Template < CacheDependendRecord
  %i[image font font2].each do |file|
    has_one_attached file

    define_method(:"#{file}_path") do
      ActiveStorage::Blob.service.path_for(public_send(file).key) if public_send(file).attached?
    end
    define_method(:"#{file}_hint") do
      "Zur Zeit: #{public_send(file).filename}" if public_send(file).attached?
    end
  end

  validates :image, content_type: { in: %i[png jpg jpeg] }
  validates :font, :font2, content_type: { in: %w[ttf application/font-sfnt] }
  has_many :text_fields, class_name: 'Certificates::TextField', inverse_of: :template, dependent: :destroy

  accepts_nested_attributes_for :text_fields, allow_destroy: true
  validates :name, presence: true

  def to_json(*_args)
    {
      name: name,
      image: image.attached? ? Base64.encode64(image.download) : nil,
      image_content_type: image.attached? ? image.blob.content_type : nil,
      image_name: image.attached? ? image.filename : nil,
      font: font.attached? ? Base64.encode64(font.download) : nil,
      font_content_type: font.attached? ? font.blob.content_type : nil,
      font_name: font.attached? ? font.filename : nil,
      font2: font2.attached? ? Base64.encode64(font2.download) : nil,
      font2_content_type: font2.attached? ? font2.blob.content_type : nil,
      font2_name: font2.attached? ? font2.filename : nil,
      text_fields: text_fields.map(&:to_export_hash),
    }.to_json
  end
end
