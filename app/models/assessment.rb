class Assessment < ActiveRecord::Base
  belongs_to :discipline
  has_many :requests, class_name: "AssessmentRequest"
  enum gender: { female: 0, male: 1 }
  enum assessment_type: { group_competitor: 0, single_competitor: 1, out_of_competition: 2 }

  validates :name, :discipline, presence: true

  def self.requestable_for person
    where(arel_table[:gender].eq(nil).or(arel_table[:gender].eq(Person.genders[person.gender]))).select do |assessment|
      assessment.discipline.single_discipline?
    end
  end
end
