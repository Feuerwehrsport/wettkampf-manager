class FireSportStatistics::PersonSpelling < ActiveRecord::Base
  belongs_to :person
  enum gender: { female: 0, male: 1 }

  validates :last_name, :first_name, :gender, :person, presence: true
end
