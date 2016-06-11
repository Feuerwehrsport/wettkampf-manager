class Series::TeamAssessmentRows::Base < Struct.new(:team, :team_number)
  include Draper::Decoratable
  attr_reader :rank

  def self.max_points
    10
  end

  def self.decrement_points(points, rank)
    points -= 1 if points > 0
    points
  end

  def self.convert_result_rows(cup, result_rows, assessment)
    points = max_points
    rank = 1
    participations = []
    result_rows.each do |row|
      participations.push(Series::TeamParticipation.new(
        cup: cup,
        team: row.entity.fire_sport_statistics_team,
        team_number: row.entity.number,
        time: row.result_entry.time.to_i || 99999999,
        points: points,
        rank: rank,
        assessment: assessment,
      ))
      points = decrement_points(points, rank)
      rank += 1
    end
    participations
  end

  def initialize(*args)
    super(*args)
    @rank = 0
  end

  def team_id
    team.id
  end

  def add_participation(participation)
    @cups ||= {}
    @cups[participation.cup_id] ||= []
    @cups[participation.cup_id].push(participation)
  end

  def participations_for_cup(cup)
    @cups ||= {}
    (@cups[cup.id] || []).sort_by(&:assessment)
  end

  def points_for_cup(cup)
    @cups ||= {}
    @cups[cup.id] ||= []
    @cups[cup.id].map(&:points).sum
  end

  def count
    @cups ||= {}
    @cups.values.count
  end

  def points
    @cups.values.map { |cup| cup.map(&:points).sum }.sum
  end

  def best_time
    @best_time ||= begin
      @cups.values.flatten.select { |p| p.assessment.discipline == 'la' }.map(&:time).min
    end
  end

  def best_time_without_nil
    best_time || (TimeInvalid::INVALID + 1)
  end

  def <=> other
    other.points <=> points
  end

  def self.special_sort!(rows)
  end 

  def calculate_rank!(other_rows)
    other_rows.each_with_index do |rank_row, rank|
      if 0 == (self <=> rank_row)
        return @rank = (rank + 1)
      end
    end
  end
end