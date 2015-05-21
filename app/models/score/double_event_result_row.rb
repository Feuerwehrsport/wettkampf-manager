module Score
  class DoubleEventResultRow < Struct.new(:entity)
    include Draper::Decoratable
    attr_reader :result_rows

    def add_result_row result_row
      @result_rows ||= []
      @result_rows.push(result_row)
    end

    def sum_stopwatch_time
      @sum_time ||= begin
        time = @result_rows.map(&:best_stopwatch_time).map(&:time).sum
        StopwatchTime.new(time: time)        
      end
    end

    def time_from result
      @result_rows.select { |row| row.result == result }.map(&:best_stopwatch_time).first
    end

    def <=> other
      self.sum_stopwatch_time <=> other.sum_stopwatch_time
    end
  end
end
