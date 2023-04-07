# frozen_string_literal: true

class Team < CacheDependendRecord
  include Taggable

  has_many :people, dependent: :nullify
  belongs_to :band, class_name: 'Band'
  belongs_to :fire_sport_statistics_team, class_name: 'FireSportStatistics::Team'
  belongs_to :federal_state
  has_many :requests, class_name: 'AssessmentRequest', as: :entity, dependent: :destroy, inverse_of: :entity
  has_many :list_entries, class_name: 'Score::ListEntry', as: :entity, dependent: :destroy, inverse_of: :entity
  has_many :requested_assessments, through: :requests, source: :assessment
  has_many :team_relays, dependent: :destroy

  validates :name, :band, :number, :shortcut, presence: true
  validates :number, numericality: { greater_than: 0 }
  validates :name, uniqueness: { scope: %i[number band], case_sensitive: false }
  validates :shortcut, length: { maximum: 12 }
  before_validation :strip_names

  accepts_nested_attributes_for :requests, allow_destroy: true

  default_scope { order(:name, :number) }

  after_create :create_assessment_requests
  attr_accessor :disable_autocreate_assessment_requests

  def request_for(assessment)
    requests.find_by(assessment: assessment)
  end

  def list_entries_group_competitor(assessment)
    @list_entries_group_competitor = {} if @list_entries_group_competitor.nil?
    @list_entries_group_competitor[assessment.id] ||= begin
      people.includes(:list_entries).count do |person|
        person.list_entries.select { |l| l.assessment_id == assessment.id }.find(&:group_competitor?).present?
      end
    end
  end

  def people_assessments
    @people_assessments ||= begin
      Assessment.where(id: Score::ListEntry.where(entity: people).distinct.pluck(:assessment_id))
    end
  end

  def fire_sport_statistics_team_with_dummy
    fire_sport_statistics_team.presence || FireSportStatistics::Team.dummy(self)
  end

  def assessment_request_group_competitor_valid?
    @assessment_request_group_competitor_valid ||= begin
      Assessment.no_double_event.all.all? do |assessment|
        people.count do |person|
          person.requests.assessment_type(:group_competitor).where(assessment: assessment).exists?
        end <= Competition.one.group_run_count
      end
    end
  end

  private

  def strip_names
    self.name = name.try(:strip)
    self.shortcut = shortcut.try(:strip)
  end

  def create_assessment_requests
    return if disable_autocreate_assessment_requests.present?

    Assessment.requestable_for_team(band).each do |assessment|
      count = assessment.fire_relay? ? 2 : 1
      requests.create(assessment: assessment, relay_count: count)
    end
  end
end
