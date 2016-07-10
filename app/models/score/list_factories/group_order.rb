class Score::ListFactories::GroupOrder < Score::ListFactory

  def self.generator_possible?(discipline)
    discipline.single_discipline?
  end

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
    team_requests = sort_or_shuffle(teams)
    loop do
      break if team_requests.blank?
      requests.push(team_requests.first.shift)
      team_requests.rotate!
      team_requests.select!(&:present?)
    end
    requests
  end

  def sort_or_shuffle(hash)
    if team_shuffle?
      hash.values.shuffle
    else
      Team.where(id: hash.keys).reorder(:lottery_number).pluck(:id).map { |id| hash[id] }
    end
  end
end