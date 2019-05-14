class FireSportStatistics::PersonSpelling < ActiveRecord::Base
  belongs_to :person, class_name: 'FireSportStatistics::Person', inverse_of: :spellings
  enum gender: { female: 0, male: 1 }

  validates :last_name, :first_name, :gender, :person, presence: true
end
