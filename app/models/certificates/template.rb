module Certificates
  class Template < ActiveRecord::Base
    mount_uploader :image, ImageUploader
    mount_uploader :font, FontUploader
    has_many :text_positions, dependent: :destroy

    accepts_nested_attributes_for :text_positions, allow_destroy: true
    validates :name, presence: true
  end
end
