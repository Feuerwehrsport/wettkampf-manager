# frozen_string_literal: true

FireSportStatistics::PersonSuggestion = Struct.new(:person) do
  include Draper::Decoratable
  delegate :first, :present?, to: :suggestions

  def suggestions
    @suggestions ||= FireSportStatistics::Person.for_person(person)
  end

  def match?
    match = suggestions.count == 1
    person.fire_sport_statistics_person_id = first.id if match
    match
  end
end
