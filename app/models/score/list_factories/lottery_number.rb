class Score::ListFactories::LotteryNumber < Score::ListFactory
  def self.generator_possible?(discipline)
    discipline.group_discipline? && Competition.one.lottery_numbers? && !discipline.is_a?(Disciplines::FireRelay)
  end

  protected

  def perform_rows
    assessment_requests
  end
end