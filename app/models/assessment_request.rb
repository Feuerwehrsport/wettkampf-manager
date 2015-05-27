class AssessmentRequest < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :entity, polymorphic: true
  enum assessment_type: { group_competitor: 0, single_competitor: 1, out_of_competition: 2 }

  validates :assessment, :entity, presence: true
  validates :group_competitor_order, numericality: { greater_than_or_equal_to: 0 }

  after_initialize :assign_next_free_group_competitor_order
  before_save :set_valid_group_competitor_order

  def self.group_assessment_type_keys
    [:group_competitor, :out_of_competition]
  end

  def next_free_group_competitor_order
    return 0 if entity.is_a?(Team) || entity.team.nil?
    free = 1
    AssessmentRequest.where(
      assessment: assessment, 
      assessment_type: AssessmentRequest.assessment_types[:group_competitor], 
      entity: entity.team.people,
    ).where.not(group_competitor_order: 0).order(:group_competitor_order).pluck(:group_competitor_order).each do |existing|
      return free if free < existing
      free += 1
    end
    return free
  end

  private

  def set_valid_group_competitor_order
    if entity.is_a?(Team) || entity.team.nil? || !group_competitor?
      self.group_competitor_order = 0
    elsif group_competitor_order == 0
      self.group_competitor_order = next_free_group_competitor_order
    end
  end

  def assign_next_free_group_competitor_order
    self.group_competitor_order = next_free_group_competitor_order if !persisted? && group_competitor_order == 0
  end
end
