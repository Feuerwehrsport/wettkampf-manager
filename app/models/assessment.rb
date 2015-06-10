class Assessment < ActiveRecord::Base
  belongs_to :discipline
  belongs_to :score_competition_result, class_name: "Score::CompetitionResult"
  has_many :requests, class_name: "AssessmentRequest", dependent: :destroy
  has_many :results, class_name: "Score::Result"
  has_many :lists, class_name: "Score::List"
  enum gender: { female: 0, male: 1 }

  validates :discipline, presence: true

  scope :gender, -> (gender) { where(gender: Assessment.genders[gender]) }

  def to_label
    decorate
  end

  def fire_relay?
    discipline.is_a?(Disciplines::FireRelay)
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
