Score::CompetitionResultRow = Struct.new(:result, :team) do
  include Draper::Decoratable
  attr_reader :assessment_results

  def add_assessment_result(assessment_result)
    @assessment_results ||= []
    @assessment_results.push(assessment_result)
  end

  def points
    @assessment_results.map(&:points).sum
  end

  def assessment_result_from(assessment)
    @assessment_results.select { |result| result.assessment == assessment }.first
  end

  def fire_attack_result_entry
    @assessment_results.select do |result|
      result.discipline.is_a?(Disciplines::FireAttack)
    end.first.try(:result_entry) || Score::ResultEntry.new(result_valid: false)
  end

  def <=>(other)
    result.result_type.nil? ? 0 : send(:"#{result.result_type}_compare", other)
  end

  def entity
    team
  end

  private

  def dcup_compare(other)
    compare = other.points <=> points
    return fire_attack_result_entry <=> other.fire_attack_result_entry if compare .zero?

    compare
  end

  def places_to_points_compare(other)
    compare = points <=> other.points
    return fire_attack_result_entry <=> other.fire_attack_result_entry if compare .zero?

    compare
  end
end
