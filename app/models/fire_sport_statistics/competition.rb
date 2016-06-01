class FireSportStatistics::Competition < ActiveRecord::Base
  validates :name, :date, presence: true
end
