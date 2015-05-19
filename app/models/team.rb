class Team < ActiveRecord::Base
  has_many :people

  enum gender: { female: 0, male: 1 }

  validates :name, :gender, :number, presence: true
  validates :number, numericality: { greater_than: 0 }
  validates :name, uniqueness: { scope: [:number, :gender] }

  scope :gender, -> (gender) { where(gender: Team.genders[gender]) }
end
