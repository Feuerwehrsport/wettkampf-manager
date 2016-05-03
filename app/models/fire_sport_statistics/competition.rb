module FireSportStatistics
  class Competition < ActiveRecord::Base
    validates :name, :date, presence: true
  end
end
