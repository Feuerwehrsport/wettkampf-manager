# frozen_string_literal: true

class Score::ListFactories::GroupOrder < Score::ListFactory
  validates :single_competitors_first, inclusion: { in: [true, false] }, if: -> { step_reached?(:finish) }

  def self.generator_possible?(discipline)
    discipline.single_discipline?
  end

  def self.generator_params
    %i[single_competitors_first]
  end

  protected

  def perform_rows
    teams = {}
    requests = []
    sorted_assessment_requests = assessment_requests.sort_by do |request|
      if single_competitors_first?
        request.single_competitor_order + ((request.group_competitor_order + 1) * 100)
      else
        ((request.single_competitor_order + 1) * 100) + request.group_competitor_order
      end
    end
    sorted_assessment_requests.each do |request|
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
      # team with most requests first
      hash.values.shuffle.sort_by(&:count).reverse
    else
      Team.where(id: hash.keys).reorder(:lottery_number).pluck(:id).map { |id| hash[id] }
    end
  end
end
