class FireSportStatistics::TeamAssociation < ApplicationRecord
  belongs_to :person, class_name: 'FireSportStatistics::Person', inverse_of: :team_associations
  belongs_to :team, class_name: 'FireSportStatistics::Team', inverse_of: :team_associations
end
