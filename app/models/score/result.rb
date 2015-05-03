module Score
  class Result < ActiveRecord::Base
    belongs_to :assessment
    has_many :lists

    validates :assessment, presence: true

    def rows
      @rows ||= generate_rows.sort
    end

    def generate_rows
      rows = {}
      lists.each do |list|
        list.entries.not_waiting.each do |list_entry|
          if rows[list_entry.entity.id].nil?
            rows[list_entry.entity.id] = Row.new(list_entry.entity)
          end
          rows[list_entry.entity.id].add_list(list_entry)
        end
      end
      rows.values
    end

    class Row < Struct.new(:entity)
      def add_list list_entry
        @list_entries ||= []
        @list_entries.push(list_entry)
      end

      def best_stopwatch_time
        @best_time ||= valid_times.first
      end

      def time_from list
        @list_entries.select { |entry| entry.list == list }.map(&:stopwatch_time).first
      end

      def valid_times
        @valid_times ||= @list_entries.select(&:result_valid?).map(&:stopwatch_time).sort
      end

      def <=> other
        return other <=> self if valid_times.count < other.valid_times.count

        valid_times.each_with_index do |time, i|
          if other.valid_times[i].present?
            compare = time <=> other.valid_times[i]
            next if compare == 0
            return compare
          else
            return 1
          end
        end
      end
    end
  end
end
