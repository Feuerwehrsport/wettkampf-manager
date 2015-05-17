class Discipline < ActiveRecord::Base
  validates :type, presence: true
  has_many :assessments
  before_destroy :destroy_possible?

  def group_discipline?
    false
  end

  def single_discipline?
    false
  end

  def to_label
    decorate.to_s
  end

  def self.types
    [
      Disciplines::ClimbingHookLadder,
      Disciplines::FireAttack,
      Disciplines::FireRelay,
      Disciplines::ObstacleCourse,
      Disciplines::GroupRelay,
    ]
  end

  def destroy_possible?
    assessments.empty?
  end

  def image
    self.class.name.demodulize.underscore
  end
end
