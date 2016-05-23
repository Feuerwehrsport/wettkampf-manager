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
        time = result_rows.map(&:best_stopwatch_time).map(&:time).sum
        StopwatchTime.aggregated_time(time)        
      end
    end

    def time
      sum_stopwatch_time
    end

    def time_from result
      result_rows.select { |row| row.result == result }.map(&:best_stopwatch_time).first
    end

    def <=> other
      compare = sum_stopwatch_time <=> other.sum_stopwatch_time
      return compare if compare != 0
      if entity.gender.to_s == "female"
        compare = obstacle_course_time <=> other.obstacle_course_time
        return compare if compare != 0
        climbing_hook_ladder_time <=> other.climbing_hook_ladder_time
      else
        compare = climbing_hook_ladder_time <=> other.climbing_hook_ladder_time
        return compare if compare != 0
        obstacle_course_time <=> other.obstacle_course_time
      end
    end

    def result_rows
      @result_rows.presence || []
    end

    protected

    def climbing_hook_ladder_time
      time_by_discipline(Disciplines::ClimbingHookLadder)
    end
    
    def obstacle_course_time
      time_by_discipline(Disciplines::ObstacleCourse)
    end

    def time_by_discipline(discipline_class)
      result_rows.find { |row| row.result.assessment.discipline.is_a?(discipline_class) }.try(:best_stopwatch_time)
    end
  end
end