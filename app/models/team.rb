class Team < CacheDependendRecord
  include Taggable

  has_many :people, dependent: :nullify
  belongs_to :fire_sport_statistics_team, class_name: 'FireSportStatistics::Team'
  has_many :requests, class_name: "AssessmentRequest", as: :entity, dependent: :destroy
  has_many :list_entries, class_name: "Score::ListEntry", as: :entity, dependent: :destroy
  has_many :requested_assessments, through: :requests, source: :assessment
  has_many :team_relays, dependent: :destroy

  enum gender: { female: 0, male: 1 }

  validates :name, :gender, :number, :shortcut, presence: true
  validates :number, numericality: { greater_than: 0 }
  validates :name, uniqueness: { scope: [:number, :gender] }
  validates :shortcut, length: { maximum: 12 }

  accepts_nested_attributes_for :requests, allow_destroy: true

  default_scope { order(:gender, :name, :number) }
  scope :gender, -> (gender) { where(gender: Team.genders[gender]) }

  after_create :create_assessment_requests
  attr_accessor :disable_autocreate_assessment_requests

  def request_for assessment
    requests.where(assessment: assessment).first
  end

  def list_entries_group_competitor assessment
    @list_entries_group_competitor = {} if @list_entries_group_competitor.nil?
    @list_entries_group_competitor[assessment.id] ||= begin
      people.includes(:list_entries).select do |person|
        person.list_entries.select { |l| l.assessment_id == assessment.id }.find { |l| l.group_competitor? }.present?
      end.count
    end
  end

  def people_assessments
    @people_assessments ||= begin
      Assessment.where(id: Score::ListEntry.where(entity: people).pluck(:assessment_id).uniq)
    end
  end

  def fire_sport_statistics_team_with_dummy
    fire_sport_statistics_team.presence || FireSportStatistics::Team.dummy(self)
  end

  def list_entries_group_competitor_valid?
    @list_entries_group_competitor_valid ||= begin
      people_assessments.map do |assessment|
        list_entries_group_competitor(assessment) <= Competition.one.group_run_count
      end.all?
    end
  end

  private

  def create_assessment_requests
    unless disable_autocreate_assessment_requests.present?
      Assessment.requestable_for(self).each do |assessment|
        count = assessment.fire_relay? ? 2 : 1
        self.requests.create(assessment: assessment, relay_count: count)
      end
    end
  end
end
