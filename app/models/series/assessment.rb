class Series::Assessment < ActiveRecord::Base
  include Genderable

  belongs_to :round, class_name: 'Series::Round'
  has_many :cups, through: :round, class_name: 'Series::Cup'
  has_many :participations, class_name: 'Series::Participation'

  scope :with_person, -> (person_id) { joins(:participations).where(series_participations: { person_id: person_id }).uniq }
  scope :round, -> (round_id) { where(round_id: round_id) }
  scope :year, -> (year) { joins(:round).where(series_rounds: { year: year }) }
  scope :round_name, -> (round_name) { joins(:round).where(series_rounds: { name: round_name }) }

  validates :round, :discipline, :gender, presence: true

  def rows
    @rows ||= calculate_rows
  end

  def aggregate_class
    @aggregate_class ||= "Series::ParticipationRows::#{round.aggregate_type}".constantize
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
      entities[participation.entity_id] ||= aggregate_class.new(participation.entity)
      entities[participation.entity_id].add_participation(participation)
    end
    result = Score::Result.where(series_person_assessment: self).first
    if result.present?
      aggregate_class.convert_result_rows(Series::Cup.today_cup_for_round(round), result.rows).each do |row|
        entities[row.entity_id] ||= aggregate_class.new(row.entity)
        entities[row.entity_id].add_participation(row)
      end
    end
    entities
  end
end