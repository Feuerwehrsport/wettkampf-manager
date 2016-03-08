module FireSportStatistics
  class ImportSuggestions
    def initialize
      ActiveRecord::Base.transaction do
        TeamAssociation.destroy_all
        TeamSpelling.destroy_all
        PersonSpelling.destroy_all
        Team.destroy_all
        Person.destroy_all

        people = []
        teams = []
        fetch(:people) do |person|
          people[person.id.to_i] = Person.create!(
            last_name: person.last_name,
            first_name: person.first_name,
            gender: person.gender,
            external_id: person.id,
          )
        end

        fetch(:teams) do |team|
          teams[team.id.to_i] = Team.create!(
            name: team.name,
            short: team.shortcut,
            external_id: team.id,
          )
        end
        
        fetch(:team_members) do |association|
          TeamAssociation.create!(
            person: people[association.person_id.to_i],
            team: teams[association.team_id.to_i],
          )
        end
        
        fetch(:team_spellings) do |spelling|
          TeamSpelling.create!(
            team: teams[spelling.team_id.to_i],
            name: spelling.name,
            short: spelling.shortcut,
          )
        end
        
        fetch(:person_spellings) do |spelling|
          PersonSpelling.create!(
            person: people[spelling.person_id.to_i],
            last_name: spelling.last_name,
            first_name: spelling.first_name,
            gender: spelling.gender,
          )
        end
      end
    end

    def fetch(key)
      collection = API::Get.fetch(key)
      all_count = collection.count.to_f
      collection.each_with_index do |entry, index|
        yield(entry)
        print "#{key}: #{(index.to_f/all_count*100).round}%\r"
        STDOUT.flush
      end
      puts ""
    end
  end
end