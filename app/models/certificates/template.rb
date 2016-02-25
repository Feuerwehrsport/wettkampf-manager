module Certificates
  class Template < ActiveRecord::Base
    mount_uploader :image, ImageUploader
    has_many :text_positions, dependent: :destroy

    accepts_nested_attributes_for :text_positions, allow_destroy: true
    validates :image, :name, presence: true
  end
end
