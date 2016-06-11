class Series::Round < ActiveRecord::Base
  include Series::Participationable

  has_many :cups, class_name: 'Series::Cup'
  has_many :assessments, class_name: 'Series::Assessment'
  has_many :participations, through: :assessments, class_name: 'Series::Participation'

  validates :name, :year, :aggregate_type, presence: true

  default_scope -> { order(year: :desc, name: :asc) }
  scope :cup_count, -> do
    select("#{table_name}.*, COUNT(#{Cup.table_name}.id) AS cup_count").
    joins(:cups).
    group("#{table_name}.id")
  end
  scope :with_team, -> (team_id, gender) do
    joins(:participations).where(series_participations:  { team_id: team_id }).merge(Series::TeamAssessment.gender(gender)).uniq
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
    rows = {}
    [:female, :male].each do |gender|
      rows[gender] = teams(gender).values.sort
      rows[gender].each { |row| row.calculate_rank!(rows[gender]) }
      rows[gender].each { |row| aggregate_class.special_sort!(rows[gender]) }
    end
    rows
  end

  def teams(gender)
    teams = {}
    Series::TeamParticipation.where(assessment: assessments.gender(gender)).each do |participation|
      teams[participation.entity_id] ||= aggregate_class.new(participation.team, participation.team_number)
      teams[participation.entity_id].add_participation(participation)
    end
    assessments.gender(gender).each do |assessment|
      result = Score::Result.where(series_team_assessment: assessment).first
      if result.present?
        rows =  result.discipline.single_discipline? ? Score::GroupResult.new(result).rows : result.group_result_rows
        aggregate_class.convert_result_rows(Series::Cup.today_cup_for_round(self), rows, assessment).each do |row|
          teams[row.entity_id] ||= aggregate_class.new(row.team, row.team_number)
          teams[row.entity_id].add_participation(row)
        end
      end
    end
    teams
  end
end