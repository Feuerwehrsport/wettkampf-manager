class AssessmentRequest < CacheDependendRecord
  belongs_to :assessment
  belongs_to :entity, polymorphic: true
  enum assessment_type: { group_competitor: 0, single_competitor: 1, out_of_competition: 2, competitor: 3 }

  validates :assessment, :entity, presence: true
  validates :group_competitor_order, :single_competitor_order, numericality: { greater_than_or_equal_to: 0 }
  validates :relay_count, numericality: { greater_than_or_equal_to: 0 }

  after_initialize :assign_next_free_competitor_order
  before_save :set_valid_competitor_order

  scope :assessment_type, ->(type) { where(assessment_type: AssessmentRequest.assessment_types[type]) }
  scope :for_assessment, ->(assessment) do
                           where(entity_type: assessment.discipline.group_discipline? ? 'Team' : 'Person')
                         end

  def self.group_assessment_type_keys
    %i[group_competitor out_of_competition]
  end

  def self.possible_assessment_types(assessment)
    assessment.discipline.group_discipline? ? [:competitor] : %i[group_competitor single_competitor out_of_competition]
  end

  private

  def next_free_competitor_order(type)
    return 0 if entity.nil? || entity.is_a?(Team) || entity.team.nil?

    free = 1
    type_order = :"#{type}_competitor_order"
    assessment.requests.where(
      assessment_type: AssessmentRequest.assessment_types[:"#{type}_competitor"],
      entity: entity.team.people,
    ).where.not(type_order => 0).order(type_order).pluck(type_order).each do |existing|
      return free if free < existing

      free += 1
    end
    free
  end

  def set_valid_competitor_order
    if entity.is_a?(Team) || entity.team.nil?
      self.group_competitor_order = 0
      self.single_competitor_order = 0
    elsif group_competitor?
      self.group_competitor_order = next_free_competitor_order(:group) if group_competitor_order .zero?
      self.single_competitor_order = 0
    elsif single_competitor?
      self.single_competitor_order = next_free_competitor_order(:single) if single_competitor_order .zero?
      self.group_competitor_order = 0
    end
  end

  def assign_next_free_competitor_order
    return if persisted?

    self.group_competitor_order = next_free_competitor_order(:group) if group_competitor_order .zero?
    self.single_competitor_order = next_free_competitor_order(:single) if single_competitor_order .zero?
  end
end
