class FireSportStatistics::TeamSuggestionDecorator < ApplicationDecorator
  decorates_association :team
  decorates_association :first
end