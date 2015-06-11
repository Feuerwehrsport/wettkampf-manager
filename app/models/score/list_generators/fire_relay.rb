module Score
  class ListGenerators::FireRelay < ListGenerator
    validate :list_assessment_match_fire_relay

    protected

    def perform_rows
      number_requests = {}
      assessment.requests.to_a.shuffle.each do |request|
        (1..request.relay_count).each do |number|
          number_requests[number] ||= []
          relay = TeamRelay.find_or_create_by!(team: request.entity, number: number)
          number_requests[number].push(OpenStruct.new(entity: relay, assessment_type: request.assessment_type))
        end
      end
      number_requests.values.flatten
    end

    private

    def list_assessment_match_fire_relay
      errors.add(:base, "Als Wertungsgruppe muss eine Staffeldisziplin gewählt werden") unless list.assessment.fire_relay?
    end
  end
end