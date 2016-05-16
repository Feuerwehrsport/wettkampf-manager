module Score
  class CompetitionResultRow < Struct.new(:competition_result, :team)
    include Draper::Decoratable
    attr_reader :assessment_results

    def add_assessment_result assessment_result
      @assessment_results ||= []
      @assessment_results.push(assessment_result)
    end

    def points
      @assessment_results.map(&:points).sum
    end

    def best_stopwatch_time
      @best_time ||= valid_times.first
    end

    def assessment_result_from assessment
      @assessment_results.select { |result| result.assessment == assessment }.first
    end

    def fire_attack_time
      time = @assessment_results.select do |result|
        result.discipline.is_a? Disciplines::FireAttack
      end.first.try(:time)
      StopwatchTime.aggregated_time(time)
    end

    def <=> other
      competition_result.result_type.nil? ? 0 : send(:"#{competition_result.result_type}_compare", other)
    end

    private

    def dcup_compare other
      compare = other.points <=> points
      return fire_attack_time <=> other.fire_attack_time if compare == 0
      compare
    end

    def places_to_points_compare other
      compare = points <=> other.points
      return fire_attack_time <=> other.fire_attack_time if compare == 0
      compare
    end
  end
end
