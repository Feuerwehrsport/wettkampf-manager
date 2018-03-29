class API::TimeEntry < ActiveRecord::Base
  include Score::ResultEntrySupport
  belongs_to :score_list_entry, class_name: 'Score::ListEntry'
  attr_accessor :password

  validates :time, presence: true
  validate :password_matches, on: :create

  accepts_nested_attributes_for :score_list_entry
  scope :waiting, -> { where(used_at: nil).order(:created_at) }
  scope :closed, -> { where.not(used_at: nil).order(created_at: :desc) }

  def self.next_waiting_entry
    waiting.first
  end

  def score_list_entry=(list_entry)
    super
    list_entry.time = time
    list_entry.result_type = :valid
    self.used_at = Time.current
  end

  private

  def password_matches
    return if User.authenticate('admin', password).present? || User.authenticate('API', password).present?
    errors.add(:password, :invalid)
  end
end
