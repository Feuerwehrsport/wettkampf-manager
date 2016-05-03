module Series
  class Round < ActiveRecord::Base
    include Participationable

    has_many :cups 
    has_many :assessments
    has_many :participations, through: :assessments

    validates :name, :year, :aggregate_type, presence: true

    default_scope -> { order(year: :desc, name: :asc) }
    scope :cup_count, -> do
      select("#{table_name}.*, COUNT(#{Cup.table_name}.id) AS cup_count").
      joins(:cups).
      group("#{table_name}.id")
    end
    scope :with_team, -> (team_id, gender) do
      joins(:participations).where(series_participations:  { team_id: team_id }).merge(TeamAssessment.gender(gender)).uniq
    end
    scope :with_local_results, -> do
      assessment_ids = Score::Result.pluck(:series_team_assessment_id) + Score::Result.pluck(:series_person_assessment_id)
      joins(:assessments).where(series_assessments: { id: assessment_ids })
    end

    def disciplines
      assessments.pluck(:discipline).uniq.sort
    end

    def team_assessment_rows(gender, cache=true)
      @team_assessment_rows ||= calculate_rows(cache)
      @team_assessment_rows[gender]
    end

    def aggregate_class
      @aggregate_class ||= "Series::TeamAssessmentRows::#{aggregate_type}".constantize
    end

    def self.for_team(team_id, gender)
      round_structs = {}
      Series::Round.with_team(team_id, gender).decorate.each do |round|
        round_structs[round.name] ||= []
        round.team_assessment_rows(gender).select { |r| r.team.id == team_id }.each do |row|
          next if row.rank.nil?
          round_structs[round.name].push OpenStruct.new(
            round: round,
            cups: round.cups,
            row: row.decorate,
            team_number: row.team_number,
          )
        end
        round_structs.delete(round.name) if round_structs[round.name].empty?
      end
      round_structs
    end

    protected

    def calculate_rows(cache)
      # Caching::Cache.fetch(caching_key(:calculate_rows), force: !cache) do
        rows = {}
        [:female, :male].each do |gender|
          rows[gender] = teams(gender).values.sort
          rows[gender].each { |row| row.calculate_rank!(rows[gender]) }
          rows[gender].each { |row| aggregate_class.special_sort!(rows[gender]) }
        end
        rows
      # end
    end

    def teams(gender)
      teams = {}
      TeamParticipation.where(assessment: assessments.gender(gender)).each do |participation|
        teams[participation.entity_id] ||= aggregate_class.new(participation.team, participation.team_number)
        teams[participation.entity_id].add_participation(participation)
      end
      teams
    end
  end
end
