class Competition < ActiveRecord::Base
  before_destroy { false }
  before_create { create_possible || false }

  attr_accessor :create_possible

  validates :name, :date, presence: true
end
