# frozen_string_literal: true

class Series::PersonParticipation < Series::Participation
  belongs_to :person, class_name: 'FireSportStatistics::Person', inverse_of: :series_participations

  validates :person, presence: true

  def entity
    person
  end

  def entity_id
    person_id
  end
end
