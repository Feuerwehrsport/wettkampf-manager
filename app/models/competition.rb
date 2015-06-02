class Competition < ActiveRecord::Base
  before_destroy { false }
  before_create { create_possible || false }

  attr_accessor :create_possible

  validates :name, :date, presence: true
  validates :group_people_count, :group_run_count, :group_score_count, numericality: { greater_than: 0 }

  def self.one
    @one ||= first
  end
end
