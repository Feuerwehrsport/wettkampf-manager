module Score
  class ListGenerators::GroupOrder < ListGenerator

    protected

    def perform_rows
      teams = {}
      requests = []
      assessment.requests.order("single_competitor_order + ((group_competitor_order + 1) * 100)").each do |request|
        teams[request.entity.team_id] ||= []
        teams[request.entity.team_id].push(request)
      end
      team_requests = teams.values.shuffle
      loop do
        requests.push(team_requests.first.shift)
        team_requests.rotate!
        team_requests.select!(&:present?)
        break if team_requests.blank?
      end
      requests
    end
  end
end