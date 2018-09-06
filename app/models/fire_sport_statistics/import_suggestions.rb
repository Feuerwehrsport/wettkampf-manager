class FireSportStatistics::ImportSuggestions < FireSportStatistics::Import
  def initialize(quiet = false)
    @quiet = quiet

    ActiveRecord::Base.transaction do
      destroy_old_imports
      import_people
      import_teams
      import_team_members
      import_team_spellings
      import_person_spellings
      import_series_rounds
      import_series_cups
      import_series_assessments
      import_series_participations

      Series::Cup.create_today!
    end
  end

  protected

  def import_people
    fetch(:people) do |person|
      people[person.id.to_i] = FireSportStatistics::Person.create!(
        id: person.id,
        last_name: person.last_name,
        first_name: person.first_name,
        gender: person.gender,
      )
    end
  end

  def import_teams
    fetch(:teams) do |team|
      teams[team.id.to_i] = FireSportStatistics::Team.create!(
        id: team.id,
        name: team.name,
        short: team.shortcut,
        federal_state: FederalState.find_by(shortcut: team.state),
      )
    end
  end

  def import_team_members
    fetch(:team_members) do |association|
      FireSportStatistics::TeamAssociation.create!(
        person: people[association.person_id.to_i],
        team: teams[association.team_id.to_i],
      )
    end
  end

  def import_team_spellings
    fetch(:team_spellings) do |spelling|
      FireSportStatistics::TeamSpelling.create!(
        team: teams[spelling.team_id.to_i],
        name: spelling.name,
        short: spelling.shortcut,
      )
    end
  end

  def import_person_spellings
    fetch(:person_spellings) do |spelling|
      FireSportStatistics::PersonSpelling.create!(
        person: people[spelling.person_id.to_i],
        last_name: spelling.last_name,
        first_name: spelling.first_name,
        gender: spelling.gender,
      )
    end
  end

  def import_series_rounds
    fetch('series/rounds') do |round|
      if round.year.to_i >= Time.zone.today.year - 1
        series_rounds[round.id.to_i] = Series::Round.create!(
          id: round.id,
          name: round.name,
          year: round.year,
          aggregate_type: round.aggregate_type,
        )
      end
    end
  end

  def import_series_cups
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
  end

  def import_series_assessments
    fetch('series/assessments') do |assessment|
      if series_rounds[assessment.round_id.to_i].present?
        discipline = assessment.discipline.to_sym
        discipline = :hb if discipline == :hw
        discipline = :zk if discipline == :zw

        series_assessments[assessment.id.to_i] = Series::Assessment.create!(
          id: assessment.id,
          name: assessment.name,
          discipline: discipline,
          round: series_rounds[assessment.round_id.to_i],
          gender: assessment.gender,
          type: assessment.type,
        )
      end
    end
  end

  def import_series_participations
    fetch('series/participations') do |participation|
      if series_cups[participation.cup_id.to_i].present? &&
         series_assessments[participation.assessment_id.to_i].present?
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
    FireSportStatistics::TeamAssociation.delete_all
    FireSportStatistics::TeamSpelling.delete_all
    FireSportStatistics::PersonSpelling.delete_all
    FireSportStatistics::Team.delete_all
    FireSportStatistics::Person.delete_all

    Series::Participation.delete_all
    Series::Assessment.delete_all
    Series::Cup.delete_all
    Series::Round.delete_all
  end
end
