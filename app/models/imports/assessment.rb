class Imports::Assessment < CacheDependendRecord
  belongs_to :configuration, class_name: 'Imports::Configuration'
  belongs_to :assessment, class_name: '::Assessment'
  validates :gender, :discipline, :configuration, :foreign_key, presence: true

  before_create do
    self.assessment = possible_assessments.first
  end

  def discipline_model
    ::Discipline.for_key(discipline)
  end

  def possible_assessments
    ::Assessment.discipline(discipline_model).gender(gender)
  end
end
