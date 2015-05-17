module Score
  class ResultRow < Struct.new(:entity)
    include Draper::Decoratable
    attr_reader :list_entries

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
      both = [valid_times, other.valid_times].map(&:count)
      (0..both.min).each do |i|
        compare = valid_times[i] <=> other.valid_times[i]
        next if compare == 0
        return compare
      end
      both.first <=> both.last
    end
  end
end
