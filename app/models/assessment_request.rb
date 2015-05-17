class AssessmentRequest < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :entity, polymorphic: true
  enum assessment_type: { group_competitor: 0, single_competitor: 1, out_of_competition: 2 }

  validates :assessment, :entity, presence: true
end
