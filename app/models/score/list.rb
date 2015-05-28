require 'score'

module Score
  class List < ActiveRecord::Base
    enum result_time_type: { electronic: 0, handheld_median: 1, handheld_average: 2, calculated: 3 }
    belongs_to :assessment
    belongs_to :result
    has_many :entries, -> { order(:run).order(:track) }, class_name: "Score::ListEntry", dependent: :destroy
    validates :name, :assessment, :track_count, presence: true
    validates :track_count, numericality: { greater_than: 0 }
    validates :generator, on: :create, presence: true
    validates :result_time_type, inclusion: { in: proc { |l| l.available_time_types.map(&:to_s) } }, allow_nil: true
    validate { generator.try(:valid?) }

    accepts_nested_attributes_for :entries, allow_destroy: true

    attr_accessor :generator
    after_create :perform_generator

    default_scope { includes(:assessment).order("assessments.discipline_id", "assessments.gender") }

    def generator= generator
      if generator.present?
        @generator = generator.constantize.new(list: self) rescue nil
      else
        @generator = generator
      end
      if @generator_attributes.present?
        generator_attributes = @generator_attributes
      end
    end

    def next_free_track
      last_entry = entries.last
      run = last_entry.try(:run) || 1
      track = last_entry.try(:track) || 1
      track += 1
      if track > track_count
        track = 1
        run += 1
      end
      [run, track]
    end

    def generator_attributes= attributes
      if @generator.present?
        attributes.each do |key, value|
          @generator.send("#{key}=".to_sym, value)
        end
        @generator_attributes = nil
      else
        @generator_attributes = attributes
      end
    end

    def open?
      result_time_type.nil?
    end

    def perform_generator
      generator.perform
    end

    def electronic_time_all_available?
      entries.result_valid.map(&:electronic_time_available).all? && electronic_time_any_available?
    end

    def electronic_time_any_available?
      entries.result_valid.electronic_time_available.present?
    end

    def handheld_time_count
      entries.result_valid.map(&:handheld_time_count).min || 0
    end

    def handheld_time_count_for_non_electronic_time
      entries.result_valid.where.not(id: entries.result_valid.electronic_time_available).map(&:handheld_time_count).min || 0
    end

    def available_time_types
      handheld_count = handheld_time_count
      types = []
      types.push(:electronic) if electronic_time_all_available?
      types.push(:handheld_median) if handheld_count === 3
      types.push(:handheld_average) if handheld_count > 0
      types.push(:calculated) if handheld_time_count_for_non_electronic_time > 0
      types
    end
  end
end
