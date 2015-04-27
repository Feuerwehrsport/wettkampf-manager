class Person < ActiveRecord::Base
  belongs_to :team
  has_many :requests, class_name: "AssessmentRequest", as: :entity
  has_many :requested_assessments, through: :requests, source: :assessment
  enum gender: { female: 0, male: 1 }

  validates :last_name, :first_name, :gender, presence: true
  validate :validate_team_gender
 
  private

  def validate_team_gender
    errors.add(:team, :has_other_gender) if team.gender != gender
  end
end
