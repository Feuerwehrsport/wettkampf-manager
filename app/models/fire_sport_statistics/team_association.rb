class FireSportStatistics::TeamAssociation < ActiveRecord::Base
  belongs_to :person, class_name: 'FireSportStatistics::Person'
  belongs_to :team, class_name: 'FireSportStatistics::Team'
end
