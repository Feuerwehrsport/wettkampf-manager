class Series::Assessment < ApplicationRecord
  include Genderable
  include Series::Importable

  belongs_to :round, class_name: 'Series::Round', inverse_of: :assessments
  has_many :cups, through: :round, class_name: 'Series::Cup'
  has_many :participations, class_name: 'Series::Participation', dependent: :destroy, inverse_of: :assessment
  has_many :assessment_results, class_name: 'Series::AssessmentResult', dependent: :destroy, inverse_of: :assessment
  has_many :score_results, through: :assessment_results

  scope :with_person, ->(person_id) do
                        joins(:participations).where(series_participations: { person_id: person_id }).distinct
                      end
  scope :round, ->(round_id) { where(round_id: round_id) }
  scope :year, ->(year) { joins(:round).where(series_rounds: { year: year }) }
  scope :round_name, ->(round_name) { joins(:round).where(series_rounds: { name: round_name }) }

  validates :round, :discipline, :gender, presence: true

  def rows
    @rows ||= calculate_rows
  end

  def aggregate_class
    @aggregate_class ||= Firesport::Series::Handler.person_class_for(round.aggregate_type)
  end

  def to_label
    "#{name} (#{round.name} #{round.year})"
  end

  def discipline_model
    Discipline.types_with_key[discipline.to_sym].new
  end

  protected

  def calculate_rows
    @rows = entities.values.sort
    @rows.each { |row| row.calculate_rank!(@rows) }
  end

  def entities
    entities = {}
    participations.each do |participation|
      entities[participation.entity_id] ||= aggregate_class.new(round, participation.entity)
      entities[participation.entity_id].add_participation(participation)
    end
    result = score_results.first
    if result.present?
      cup = Series::Cup.today_cup_for_round(round)
      convert_result_rows(result.rows) do |row, time, points, rank|
        participation = Series::PersonParticipation.new(
          cup: cup,
          person: row.entity.fire_sport_statistics_person_with_dummy,
          time: time,
          points: points,
          rank: rank,
        )

        entities[participation.entity_id] ||= aggregate_class.new(round, participation.entity)
        entities[participation.entity_id].add_participation(participation)
      end
    end
    entities
  end
end
