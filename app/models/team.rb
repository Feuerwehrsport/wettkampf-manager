class Team < ActiveRecord::Base
  has_many :people
  has_many :requests, class_name: "AssessmentRequest", as: :entity, dependent: :destroy
  has_many :list_entries, class_name: "Score::ListEntry", as: :entity, dependent: :destroy
  has_many :requested_assessments, through: :requests, source: :assessment

  enum gender: { female: 0, male: 1 }

  validates :name, :gender, :number, presence: true
  validates :number, numericality: { greater_than: 0 }
  validates :name, uniqueness: { scope: [:number, :gender] }

  accepts_nested_attributes_for :requests, allow_destroy: true

  default_scope { order(:gender, :name, :number) }
  scope :gender, -> (gender) { where(gender: Team.genders[gender]) }

  after_create :create_assessment_requests

  def request_for assessment
    requests.where(assessment: assessment).first
  end

  def list_entries_group_competitor assessment
    @list_entries_group_competitor = {} if @list_entries_group_competitor.nil?
    @list_entries_group_competitor[assessment.id] ||= begin
      people.includes(:list_entries).select do |person|
        person.list_entries.select { |l| l.list.assessment_id == assessment.id }.find { |l| l.group_competitor? }.present?
      end.count
    end
  end

  def people_assessments
    @people_assessments ||= begin
      list_ids = people.includes(:list_entries).map(&:list_entries).map { |l| l.pluck(:list_id) }.flatten
      Assessment.where(id: Score::List.where(id: list_ids).pluck(:assessment_id).uniq)
    end
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
    Assessment.requestable_for(self).each do |assessment|
      self.requests.create(assessment: assessment)
    end
  end
end
