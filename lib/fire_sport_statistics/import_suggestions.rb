module FireSportStatistics
  class ImportSuggestions < Import
    def initialize(quiet = false)
      @quiet = quiet

      ActiveRecord::Base.transaction do
        destroy_old_imports

        fetch(:people) do |person|
          people[person.id.to_i] = Person.create!(
            id: person.id,
            last_name: person.last_name,
            first_name: person.first_name,
            gender: person.gender,
          )
        end

        fetch(:teams) do |team|
          teams[team.id.to_i] = Team.create!(
            id: team.id,
            name: team.name,
            short: team.shortcut,
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
        
        fetch('series/rounds') do |round|
          if round.year.to_i >= Date.today.year - 1
            series_rounds[round.id.to_i] = Series::Round.create!(
              id: round.id,
              name: round.name,
              year: round.year,
              aggregate_type: round.aggregate_type,
            )
          end
        end

        fetch('series/cups') do |cup|
          if series_rounds[cup.round_id.to_i].present?
            series_cups[cup.id.to_i] = Series::Cup.create!(
              id: cup.id,
              round: series_rounds[cup.round_id.to_i],
              competition_place: cup.place,
              competition_date: cup.date,
            )
          end
        end

        fetch('series/assessments') do |assessment|
          if series_rounds[assessment.round_id.to_i].present?
            series_assessments[assessment.id.to_i] = Series::Assessment.create!(
              id: assessment.id,
              name: assessment.name,
              discipline: assessment.discipline,
              round: series_rounds[assessment.round_id.to_i],
              gender: assessment.gender,
              type: assessment.type,
            )
          end
        end

        fetch('series/participations') do |participation|
          if series_cups[participation.cup_id.to_i].present? && series_assessments[participation.assessment_id.to_i].present?
            Series::Participation.create!(
              id: participation.id,
              points: participation.points,
              rank: participation.rank,
              time: participation.time,
              cup: series_cups[participation.cup_id.to_i],
              assessment: series_assessments[participation.assessment_id.to_i],
              type: participation.type,
              team_id: participation.team_id,
              team_number: participation.team_number,
              person_id: participation.person_id,
            )
          end
        end

        Series::Cup.create_today!
      end
    end

    def people
      @people ||= []
    end

    def teams
      @teams ||= []
    end

    def series_rounds
      @series_rounds ||= []
    end

    def series_cups
      @series_cups ||= []
    end

    def series_assessments
      @series_assessments ||= []
    end

    def destroy_old_imports
      TeamAssociation.delete_all
      TeamSpelling.delete_all
      PersonSpelling.delete_all
      Team.delete_all
      Person.delete_all

      Series::Participation.delete_all
      Series::Assessment.delete_all
      Series::Cup.delete_all
      Series::Round.delete_all
    end
  end
end