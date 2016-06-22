class Series::TeamAssessmentRows::Base < Struct.new(:team, :team_number)
  include Draper::Decoratable
  attr_reader :rank

  def self.max_points
    10
  end
  
  def self.points_for_rank(row, ranks)
    rank = ranks[row]
    double_rank_count = ranks.values.select { |v| v == rank }.count - 1
    [(max_points + 1 - ranks[row] - double_rank_count), 0].max
  end

  def self.convert_result_rows(cup, result_rows, assessment)
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
      participations.push(Series::TeamParticipation.new(
        cup: cup,
        team: row.entity.fire_sport_statistics_team_with_dummy,
        team_number: row.entity.number,
        time: row.result_entry.time.to_i || 99999999,
        points: points_for_rank(row, ranks),
        rank: ranks[row],
        assessment: assessment,
      ))
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
    best_time || (Score::ResultEntrySupport::INVALID_TIME + 1)
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