class Series::ParticipationRows::ExtraLiga < Series::ParticipationRows::Base
  def self.person_participation_attributes(row:, cup:, person:, time:, points:, rank:)
    points = (time == Score::ResultEntrySupport::INVALID_TIME) ? 9999 : time
    {
      cup: cup,
      person: person,
      time: time,
      points: points,
      rank: rank,
    }
  end

  def sum_time
    @sum_time ||= ordered_participations.map(&:time).sum
  end

  def points
    @points ||= ordered_participations.map(&:points).sum + ((4-max_count) * 9999)
  end

  def <=> other
    compare = other.max_count <=> max_count 
    return compare if compare != 0
    compare = points <=> other.points
    return compare if compare != 0
    best_time <=> other.best_time
  end

  def max_count
    @max_count ||= [count, 4].min
  end

  protected

  def ordered_participations
    @ordered_participations ||= @participations.sort do |a, b|
      compare = a.points <=> b.points
      compare == 0 ? a.time <=> b.time : compare
    end.first(4)
  end
end