class Person < ActiveRecord::Base
  belongs_to :team
  has_many :requests, class_name: "AssessmentRequest", as: :entity
  has_many :requested_assessments, through: :requests, source: :assessment
  enum gender: { female: 0, male: 1 }

  validates :last_name, :first_name, :gender, presence: true
  validate :validate_team_gender

  accepts_nested_attributes_for :requests, allow_destroy: true

  def request_for assessment
    requests.where(assessment: assessment).first
  end
 
  private

  def validate_team_gender
    errors.add(:team, :has_other_gender) if team.present? && team.gender != gender
  end
end
