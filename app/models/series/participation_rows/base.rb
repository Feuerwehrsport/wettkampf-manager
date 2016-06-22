class Series::ParticipationRows::Base < Struct.new(:entity)
  include Draper::Decoratable
  attr_reader :participations, :rank

  def self.max_points
    30
  end

  def self.points_for_rank(row, ranks)
    rank = ranks[row]
    double_rank_count = ranks.values.select { |v| v == rank }.count - 1
    [(max_points + 1 - ranks[row] - double_rank_count), 0].max
  end

  def self.convert_result_rows(cup, result_rows)
    participations = []
    ranks = {}
    result_rows.each do |row|
      result_rows.each_with_index do |rank_row, rank|
        if 0 == (row <=> rank_row)
          ranks[row] = (rank + 1)
          break
        end
      end
    end

    result_rows.each do |row|
      participations.push(Series::PersonParticipation.new(
        cup: cup,
        person: row.entity.fire_sport_statistics_person_with_dummy,
        time: row.result_entry.time.to_i || 99999999,
        points: points_for_rank(row, ranks),
        rank: ranks[row],
      ))
    end
    participations
  end

  def add_participation(participation)
    @participations ||= []
    @participations.push(participation)
  end

  def participation_for_cup(cup)
    @participations.find { |participation| participation.cup == cup }
  end

  def points
    @points ||= @participations.map(&:points).sum
  end

  def best_time
    @best_time ||= @participations.map(&:time).min
  end

  def sum_time
    @sum_time ||= @participations.map(&:time).sum
  end

  def count
    @count ||= @participations.count
  end

  def <=> other
    compare = other.points <=> points
    return compare if compare != 0
    compare = other.count <=> count 
    return compare if compare != 0
    sum_time <=> other.sum_time
  end

  def calculate_rank!(other_rows)
    other_rows.each_with_index do |rank_row, rank|
      if 0 == (self <=> rank_row)
        return @rank = (rank + 1)
      end
    end
  end
end