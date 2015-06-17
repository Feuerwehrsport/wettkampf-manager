module DCup
  class SingleCompetitorResultRow < Struct.new(:person)
    include Draper::Decoratable

    def add_result(result)
      @results ||= []
      @results.push(result)
    end

    def result_for_competition competition
      @results.find { |result| result.competition == competition }
    end

    def points
      @results.map(&:points).sum
    end

    def count
      @results.count
    end

    def time
      @results.map(&:summable_time).sum
    end

    def stopwatch_time
      Score::StopwatchTime.aggregated_time(time)
    end

    def <=> other
      compare = other.points <=> points
      return compare if compare != 0
      compare = other.count <=> count 
      return compare if compare != 0
      compare = time <=> other.time
      puts "compare: #{compare}"
      compare
    end
  end
end