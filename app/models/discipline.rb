class Discipline < ActiveRecord::Base
  validates :type, presence: true
  has_many :assessments, dependent: :restrict_with_error
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
    types_with_key.values
  end

  def self.types_with_key
    {
      hl: Disciplines::ClimbingHookLadder,
      la: Disciplines::FireAttack,
      fs: Disciplines::FireRelay,
      hb: Disciplines::ObstacleCourse,
      gs: Disciplines::GroupRelay,
      zk: Disciplines::DoubleEvent,
    }
  end

  def destroy_possible?
    assessments.empty?
  end

  def image
    self.class.name.demodulize.underscore
  end
end
