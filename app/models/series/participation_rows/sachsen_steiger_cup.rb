class Series::ParticipationRows::SachsenSteigerCup < Series::ParticipationRows::MVSingleCup
  def <=> other
    compare = other.points <=> points
    return compare if compare != 0
    compare = sum_time <=> other.sum_time
    return compare if compare != 0
    best_time <=> other.best_time
  end
end