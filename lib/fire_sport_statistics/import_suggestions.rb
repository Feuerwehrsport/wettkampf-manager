module FireSportStatistics
  class ImportSuggestions
    def initialize(verbose = false)
      @verbose = verbose

      ActiveRecord::Base.transaction do
        TeamAssociation.destroy_all
        TeamSpelling.destroy_all
        PersonSpelling.destroy_all
        Team.destroy_all
        Person.destroy_all

        people = []
        teams = []
        API::Get.people.each do |person|
          people[person.id.to_i] = Person.create!(
            last_name: person.name,
            first_name: person.firstname,
            gender: person.sex,
            external_id: person.id,
          )
          verbose_dot "p"
        end

        API::Get.teams.each do |team|
          teams[team.id.to_i] = Team.create!(
            name: team.name,
            short: team.short,
            external_id: team.id,
          )
          verbose_dot "t"
        end
        
        API::Get.team_associations.each do |association|
          TeamAssociation.create!(
            person: people[association.person_id.to_i],
            team: teams[association.team_id.to_i],
          )
          verbose_dot "a"
        end
        
        API::Get.team_spellings.each do |spelling|
          TeamSpelling.create!(
            team: teams[spelling.team_id.to_i],
            name: spelling.name,
            short: spelling.short,
          )
          verbose_dot "s"
        end
        
        API::Get.person_spellings.each do |spelling|
          PersonSpelling.create!(
            person: people[spelling.person_id.to_i],
            last_name: spelling.name,
            first_name: spelling.firstname,
            gender: spelling.sex,
          )
          verbose_dot "v"
        end
        puts "" if @verbose
      end
    end

    def verbose_dot char
      print char if @verbose
    end
  end
end