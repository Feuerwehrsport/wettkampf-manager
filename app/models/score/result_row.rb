module Score
  class ResultRow < Struct.new(:entity, :result)
    include Draper::Decoratable
    attr_reader :list_entries

    def add_list list_entry
      @list_entries ||= []
      @list_entries.push(list_entry)
    end

    def entity
      @entity ||= list_entries.first.try(:entity)
    end

    def best_stopwatch_time
      @best_time ||= valid_times.first
    end

    def time
      best_stopwatch_time
    end

    def time_from list
      @list_entries.select { |entry| entry.list == list }.map(&:stopwatch_time).first
    end

    def valid_times
      @valid_times ||= @list_entries.select(&:result_valid?).map(&:stopwatch_time).sort
    end

    def valid?
      @valid ||= valid_times.present?
    end

    def <=> other
      both = [valid_times, other.valid_times].map(&:count)
      (0..(both.min - 1)).each do |i|
        compare = valid_times[i] <=> other.valid_times[i]
        next if compare == 0
        return compare
      end
      both.last <=> both.first
    end
  end
end
