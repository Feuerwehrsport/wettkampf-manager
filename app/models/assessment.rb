class Assessment < CacheDependendRecord
  include Taggable

  belongs_to :discipline, inverse_of: :assessments
  belongs_to :score_competition_result, class_name: 'Score::CompetitionResult', inverse_of: :assessments
  has_many :requests, class_name: 'AssessmentRequest', dependent: :destroy, inverse_of: :assessment
  has_many :results, class_name: 'Score::Result', dependent: :restrict_with_error, inverse_of: :assessment
  has_many :list_assessments, class_name: 'Score::ListAssessment', dependent: :restrict_with_error,
                              inverse_of: :assessment
  has_many :lists, class_name: 'Score::List', through: :list_assessments, dependent: :restrict_with_error
  has_many :user_assessment_abilities, dependent: :destroy
  has_many :users, through: :user_assessment_abilities
  has_many :imports_assessment, class_name: 'Imports::Assessment', inverse_of: :assessment, dependent: :nullify
  enum gender: { female: 0, male: 1 }

  validates :discipline, presence: true

  scope :gender, ->(gender) { where(gender: Assessment.genders[gender]) }
  scope :no_double_event, -> { joins(:discipline).where.not(disciplines: { type: 'Disciplines::DoubleEvent' }) }
  scope :discipline, ->(discipline) { joins(:discipline).where(disciplines: { type: discipline.type }) }

  def to_label
    decorate
  end

  def fire_relay?
    discipline.like_fire_relay?
  end

  def person_tags
    @person_tags ||= tags.where(type: PersonTag)
  end

  def team_tags
    @team_tags ||= tags.where(type: TeamTag)
  end

  def self.single_discipline(gender)
    gender(gender).select { |assessment| assessment.discipline.single_discipline? }
  end

  def self.requestable_for(entity)
    g = arel_table[:gender]
    if entity.is_a? Person
      where(g.eq(nil).or(g.eq(Person.genders[entity.gender]))).select do |a|
        a.discipline.single_discipline? && (a.person_tags.blank? || entity.include_tags?(a.person_tags))
      end
    else
      where(g.eq(nil).or(g.eq(Team.genders[entity.gender]))).select do |a|
        a.discipline.group_discipline? && (a.team_tags.blank? || entity.include_tags?(a.team_tags))
      end
    end
  end
end
