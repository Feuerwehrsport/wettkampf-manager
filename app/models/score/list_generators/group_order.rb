module Score
  class ListGenerators::GroupOrder < ListGenerator

    protected

    def perform_rows
      teams = {}
      requests = []
      assessment_requests.sort_by do |request|
        request.single_competitor_order + ((request.group_competitor_order + 1) * 100)
      end.each do |request|
        teams[request.entity.team_id] ||= []
        teams[request.entity.team_id].push(request)
      end
      team_requests = teams.values.shuffle
      loop do
        break if team_requests.blank?
        requests.push(team_requests.first.shift)
        team_requests.rotate!
        team_requests.select!(&:present?)
      end
      requests
    end
  end
end