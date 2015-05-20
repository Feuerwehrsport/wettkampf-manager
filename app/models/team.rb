class Team < ActiveRecord::Base
  has_many :people
  has_many :requests, class_name: "AssessmentRequest", as: :entity
  has_many :requested_assessments, through: :requests, source: :assessment

  enum gender: { female: 0, male: 1 }

  validates :name, :gender, :number, presence: true
  validates :number, numericality: { greater_than: 0 }
  validates :name, uniqueness: { scope: [:number, :gender] }

  accepts_nested_attributes_for :requests, allow_destroy: true

  scope :gender, -> (gender) { where(gender: Team.genders[gender]) }

  def request_for assessment
    requests.where(assessment: assessment).first
  end
end
