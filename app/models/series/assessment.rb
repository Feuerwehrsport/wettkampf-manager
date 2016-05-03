module Series
  class Assessment < ActiveRecord::Base
    include Genderable

    belongs_to :round
    has_many :cups, through: :round
    has_many :participations

    scope :with_person, -> (person_id) { joins(:participations).where(series_participations: { person_id: person_id }).uniq }
    scope :round, -> (round_id) { where(round_id: round_id) }

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
        aggregate_class.convert_result_rows(Cup.today_cup_for_round(round), result.rows).each do |row|
          entities[row.entity_id] ||= aggregate_class.new(row.entity)
          entities[row.entity_id].add_participation(row)
        end
      end
      entities
    end
  end
end