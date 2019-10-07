class FireSportStatistics::PersonSpelling < ActiveRecord::Base
  include Genderable

  belongs_to :person, class_name: 'FireSportStatistics::Person', inverse_of: :spellings

  validates :last_name, :first_name, :gender, :person, presence: true
end
