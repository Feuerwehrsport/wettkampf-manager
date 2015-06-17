module FireSportStatistics
  class DCupResult < ActiveRecord::Base
    enum gender: { female: 0, male: 1 }
    validates :discipline_key, :gender, presence: true
  end
end
