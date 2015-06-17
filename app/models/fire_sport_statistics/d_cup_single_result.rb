module FireSportStatistics
  class DCupSingleResult < ActiveRecord::Base
    belongs_to :result, class_name: "FireSportStatistics::DCupResult"
    belongs_to :person
    belongs_to :competition

    validates :result, :person, :competition, presence: true
    validates :points, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 30 }
  end
end
