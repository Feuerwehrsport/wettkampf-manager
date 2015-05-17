class Assessment < ActiveRecord::Base
  belongs_to :discipline
  has_many :requests, class_name: "AssessmentRequest"
  enum gender: { female: 0, male: 1 }

  validates :discipline, presence: true

  def self.requestable_for person
    where(arel_table[:gender].eq(nil).or(arel_table[:gender].eq(Person.genders[person.gender]))).select do |assessment|
      assessment.discipline.single_discipline?
    end
  end
end
