class AssessmentRequest < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :entity, polymorphic: true

  validates :assessment, :entity, presence: true
end
