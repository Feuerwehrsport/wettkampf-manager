class Assessment < ActiveRecord::Base
  belongs_to :discipline
  has_many :requests, class_name: "AssessmentRequest"
  enum gender: { female: 0, male: 1 }

  validates :discipline, presence: true

  def to_label
    decorate
  end

  def self.requestable_for entity
    if entity.is_a? Person
      where(arel_table[:gender].eq(nil).or(arel_table[:gender].eq(Person.genders[entity.gender]))).select do |assessment|
        assessment.discipline.single_discipline?
      end
    else
      where(arel_table[:gender].eq(nil).or(arel_table[:gender].eq(Team.genders[entity.gender]))).select do |assessment|
        assessment.discipline.group_discipline?
      end
    end
  end
end
