# frozen_string_literal: true

class Person < CacheDependendRecord
  include Taggable

  belongs_to :team
  belongs_to :band, class_name: 'Band'
  belongs_to :fire_sport_statistics_person, class_name: 'FireSportStatistics::Person', inverse_of: :person
  has_many :requests, class_name: 'AssessmentRequest', as: :entity, dependent: :destroy, inverse_of: :entity
  has_many :list_entries, class_name: 'Score::ListEntry', as: :entity, dependent: :destroy, inverse_of: :entity
  has_many :requested_assessments, through: :requests, source: :assessment
  before_save :assign_registration_order

  validates :last_name, :first_name, :band, presence: true
  validate :validate_team_band
  before_validation :strip_names
  before_validation :create_team_from_name, on: :create

  accepts_nested_attributes_for :requests, allow_destroy: true

  default_scope { order(:last_name, :first_name) }
  scope :registration_order, -> { reorder(:registration_order) }

  attr_accessor :create_team_name

  def request_for(assessment)
    requests.find_by(assessment: assessment)
  end

  def fire_sport_statistics_person_with_dummy
    fire_sport_statistics_person.presence || FireSportStatistics::Person.dummy(self)
  end

  private

  def strip_names
    self.last_name = last_name.try(:strip)
    self.first_name = first_name.try(:strip)
  end

  def validate_team_band
    return if team.blank? || team.band == band

    errors.add(:team, :has_other_band)
    errors.add(:band, :has_other_band)
  end

  def assign_registration_order
    return unless registration_order.zero? && team.present?

    self.registration_order = (team.people.maximum(:registration_order) || 0) + 1
  end

  def create_team_from_name
    return if create_team_name.blank? || team&.persisted?

    self.team = Team.find_by(band: band, name: create_team_name)
    return if team&.persisted?

    build_team(disable_autocreate_assessment_requests: true,
               name: create_team_name, shortcut: create_team_name.first(12), band: band)
  end
end
