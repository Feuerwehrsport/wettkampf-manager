class Person < CacheDependendRecord
  include Genderable
  include Taggable

  belongs_to :team
  belongs_to :fire_sport_statistics_person, class_name: 'FireSportStatistics::Person', inverse_of: :person
  has_many :requests, class_name: 'AssessmentRequest', as: :entity, dependent: :destroy, inverse_of: :entity
  has_many :list_entries, class_name: 'Score::ListEntry', as: :entity, dependent: :destroy, inverse_of: :entity
  has_many :requested_assessments, through: :requests, source: :assessment
  before_save :assign_registration_order

  validates :last_name, :first_name, :gender, presence: true
  validate :validate_team_gender
  before_validation :strip_names

  accepts_nested_attributes_for :requests, allow_destroy: true

  default_scope { order(:gender, :last_name, :first_name) }
  scope :registration_order, -> { reorder(:registration_order) }

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

  def validate_team_gender
    errors.add(:team, :has_other_gender) if team.present? && team.gender != gender
    errors.add(:gender, :has_other_gender) if team.present? && team.gender != gender
  end

  def assign_registration_order
    return unless registration_order .zero? && team.present?

    self.registration_order = (team.people.maximum(:registration_order) || 0) + 1
  end
end
