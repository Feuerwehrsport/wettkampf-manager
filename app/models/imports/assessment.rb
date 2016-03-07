class Imports::Assessment < ActiveRecord::Base
  belongs_to :configuration
  belongs_to :assessment, class_name: "::Assessment"
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
