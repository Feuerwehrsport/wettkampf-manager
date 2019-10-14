class UserAssessmentAbility < ApplicationRecord
  belongs_to :user
  belongs_to :assessment

  validates :user, :assessment, presence: true
end
