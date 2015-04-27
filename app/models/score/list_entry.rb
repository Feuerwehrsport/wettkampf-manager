module Score
  class ListEntry < ActiveRecord::Base
    belongs_to :list
    belongs_to :entity, polymorphic: true
    has_many :stopwatch_times, -> { order(:type) }

    validates :list, :entity, :track, :run, presence: true
    validates :track, :run, numericality: { greater_than: 0 }
    validates :track, numericality: { less_than_or_equal_to: :track_count }

    delegate :track_count, to: :list

    after_initialize :assign_time_entries
    before_save :handle_time_entries
    attr_reader :time_entries

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
      @time_entries.select { |entry| entry.time.present? }.each do |entry|
        stopwatch_times.push(entry)
      end
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
