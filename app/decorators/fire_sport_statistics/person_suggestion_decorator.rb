module FireSportStatistics
  class PersonSuggestionDecorator < ApplicationDecorator
    decorates_association :person
    decorates_association :first
  end
end