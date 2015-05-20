module Score
  class ListEntry < ActiveRecord::Base
    belongs_to :list
    belongs_to :entity, polymorphic: true
    has_many :stopwatch_times, -> { order(:type) }, dependent: :destroy
    enum assessment_type: { group_competitor: 0, single_competitor: 1, out_of_competition: 2 }

    validates :list, :entity, :track, :run, :assessment_type, presence: true
    validates :track, :run, numericality: { greater_than: 0 }
    validates :track, numericality: { less_than_or_equal_to: :track_count }

    delegate :track_count, to: :list

    after_initialize :assign_time_entries
    before_save :handle_time_entries
    attr_reader :time_entries

    scope :result_valid, -> { where(result_type: "valid") }
    scope :electronic_time_available, -> { joins(:stopwatch_times).where(score_stopwatch_times: { type: ElectronicTime }) }
    scope :not_waiting, -> { where.not(result_type: "waiting") }

    def self.result_types
      [
        ["waiting", "-"],
        ["valid", "Gültig"],
        ["invalid", "Ungültig"],
        ["no-run", "Nicht angetreten"],
      ]
    end

    def time_entries_attributes= entries_attributes
      entries_attributes.each do |key, attributes|
        @time_entries[key.to_i].assign_attributes(attributes)
      end
      @time_entries.select { |entry| entry.valid? }.each do |entry|
        stopwatch_times.push(entry)
      end
    end

    def stopwatch_time
      stopwatch_times.first
    end

    def stopwatch_time_valid?
      stopwatch_times.count > 0
    end

    def electronic_time_available
      stopwatch_times.where(type: ElectronicTime).present?
    end

    def handheld_time_count
      stopwatch_times.where(type: HandheldTime).count
    end

    def result_waiting?
      result_type == "waiting"
    end

    def result_valid?
      result_type == "valid"
    end

    def calculated_time result_time_type=nil
      if result_time_type == :electronic
        time = stopwatch_times.where(type: ElectronicTime).first.try(:time)
      elsif result_time_type == :handheld_media
        sorted = stopwatch_times.where(type: HandheldTime).sort
        len = sorted.length
        time = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
      elsif result_time_type == :handheld_average
        time = stopwatch_times.where(type: HandheldTime).average(:time)
      elsif result_time_type == :calculated
        time = calculated_time(:electronic)
        if time.nil?
          time = calculated_time(:handheld_average) + 30
        end
        time
      else
        time = calculated_time(:electronic).time
        if time.nil?
          time = calculated_time(:handheld_average).time
        end
        time
      end
      p time
      StopwatchTime.new(list_entry: self, time: time)
    end

    protected

    def assign_time_entries
      @time_entries = stopwatch_times.to_a
      unless @time_entries.any? { |time| time.is_a? ElectronicTime }
        @time_entries.unshift(ElectronicTime.new(list_entry: self))
      end
      while @time_entries.select { |time| time.is_a? HandheldTime }.count < 3
        @time_entries.push(HandheldTime.new(list_entry: self))
      end
    end

    def handle_time_entries
      if result_type != "valid"
        stopwatch_times.select(&:persisted?).each(&:destroy)
        self.stopwatch_times = []
        assign_time_entries
      end
    end
  end
end
