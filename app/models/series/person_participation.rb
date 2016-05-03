module Series
  class PersonParticipation < Participation
    belongs_to :person, class_name: 'FireSportStatistics::Person'

    validates :person, presence: true

    def entity
      person
    end

    def entity_id
      person_id
    end
  end
end
