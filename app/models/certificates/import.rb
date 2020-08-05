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
    if json_data[:image]
      template.image = CarrierStringIO.new(json_data[:image], json_data[:image_name], json_data[:image_content_type])
    end
    if json_data[:font]
      template.font = CarrierStringIO.new(json_data[:font], json_data[:font_name], json_data[:font_content_type])
    end
    if json_data[:font2]
      template.font2 = CarrierStringIO.new(json_data[:font2], json_data[:font2_name], json_data[:font2_content_type])
    end
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

  class CarrierStringIO < StringIO
    attr_reader :original_filename, :content_type
    def initialize(base64_data, filename, content_type)
      super(Base64.decode64(base64_data))
      @original_filename = filename
      @content_type = content_type
    end
  end
end
