# frozen_string_literal: true

class Certificates::Import
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::Callbacks
  include Draper::Decoratable
  attr_accessor :file, :template

  validates :file, presence: true

  def save
    valid? && create_template
  rescue JSON::ParserError
    errors.add(:file, :invalid)
    false
  end

  def json_data
    @json_data ||= JSON.parse(file.read, symbolize_names: true)
  end

  def create_template
    self.template = Certificates::Template.new(name: json_data[:name])
    template.image.attach(attachable(:image)) if json_data[:image]
    template.font.attach(attachable(:font)) if json_data[:font]
    template.font2.attach(attachable(:font2)) if json_data[:font2]
    json_data[:text_fields].each do |text_field|
      template.text_fields.build(
        left: text_field[:left],
        top: text_field[:top],
        width: text_field[:width],
        height: text_field[:height],
        size: text_field[:size],
        key: text_field[:key],
        align: text_field[:align],
        text: text_field[:text],
        color: text_field[:color].presence || '000000',
      )
    end
    template.save
  end

  def attachable(type)
    {
      io: StringIO.new(Base64.decode64(json_data[type])),
      filename: json_data[:"#{type}_name"],
      content_type: json_data[:"#{type}_content_type"],
    }
  end
end
