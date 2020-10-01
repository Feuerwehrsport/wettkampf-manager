# frozen_string_literal: true

class Series::Round < ApplicationRecord
  include Series::Participationable
  include Series::Importable

  has_many :cups, class_name: 'Series::Cup', dependent: :destroy, inverse_of: :round
  has_many :assessments, class_name: 'Series::Assessment', dependent: :destroy, inverse_of: :round
  has_many :participations, through: :assessments, class_name: 'Series::Participation'

  validates :name, :year, :aggregate_type, presence: true

  default_scope -> { order(year: :desc, name: :asc) }
  scope :with_local_results, -> do
    assessment_ids = Series::AssessmentResult.select(:assessment_id)
    joins(:assessments).where(series_assessments: { id: assessment_ids })
  end

  def disciplines
    assessments.pluck(:discipline).uniq.sort
  end

  def team_assessment_rows(gender, cache = true)
    @team_assessment_rows ||= calculate_rows(cache)
    @team_assessment_rows[gender]
  end

  def aggregate_class
    @aggregate_class ||= Firesport::Series::Handler.team_class_for(aggregate_type)
  end

  def round
    self
  end

  protected

  def calculate_rows(_cache)
    rows = {}
    %i[female male].each do |gender|
      rows[gender] = teams(gender).values.sort
      rows[gender].each { |row| row.calculate_rank!(rows[gender]) }
      rows[gender].each { |_row| aggregate_class.special_sort!(rows[gender]) }
    end
    rows
  end

  def teams(gender)
    teams = {}
    assessments = self.assessments.where(type: 'Series::TeamAssessment')
    Series::TeamParticipation.where(assessment: assessments.gender(gender)).find_each do |participation|
      teams[participation.entity_id] ||= aggregate_class.new(self, participation.team, participation.team_number)
      teams[participation.entity_id].add_participation(participation)
    end
    assessments.gender(gender).each do |assessment|
      result = assessment.score_results.first
      next if result.blank?

      cup  = Series::Cup.today_cup_for_round(self)
      rows = result.discipline.single_discipline? ? Score::GroupResult.new(result).rows : result.group_result_rows

      convert_result_rows(rows) do |row, time, points, rank|
        participation = Series::TeamParticipation.new(
          cup: cup,
          team: row.entity.fire_sport_statistics_team_with_dummy,
          team_number: row.entity.number,
          time: time,
          points: points,
          rank: rank,
          assessment: assessment,
        )

        teams[participation.entity_id] ||= aggregate_class.new(self, participation.team, participation.team_number)
        teams[participation.entity_id].add_participation(participation)
      end
    end
    teams
  end
end
