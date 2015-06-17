module FireSportStatistics
  class Competition < ActiveRecord::Base
    validates :name, :date, :external_id, presence: true
  end
end
