class Score::CompetitionResult < CacheDependendRecord
  include Genderable

  has_many :assessments, foreign_key: :score_competition_result_id
  has_many :results, -> { where(score_results: { group_assessment: true }) }, through: :assessments, class_name: 'Score::Result'

  validates :result_type, presence: true

  def rows
    @rows ||= result_type.present? ? send(result_type) : []
  end

  def result_type
    super.presence || Competition.result_type
  end

  def self.result_types
    {
      dcup: "D-Cup",
      places_to_points: "Plätze zu Punkte",
    }
  end

  private

  def for_results
    results.each do |result|
      discipline = result.assessment.discipline
      if discipline.single_discipline?
        result_rows = Score::GroupResult.new(result).rows
      else
        result_rows = result.group_result_rows
      end


      ranks = {}
      result_rows.each do |row|
        result_rows.each_with_index do |rank_row, rank|
          if 0 == (row <=> rank_row)
            ranks[row] = (rank + 1)
            break
          end
        end
      end

      yield result, result_rows, ranks
    end
  end

  def dcup
    teams = {}
    for_results do |result, result_rows, ranks|
      points = 11
      result_rows.each do |row|

        rank = ranks[row]
        double_rank_count = ranks.values.select { |v| v == rank }.count - 1
        points = [(11 - ranks[row] - double_rank_count), 0].max
        points = 0 unless row.competition_result_valid?

        assessment_result = Score::AssessmentResult.new(points, result.assessment, row.result_entry, row.entity, row)
        teams[row.entity.id] ||= Score::CompetitionResultRow.new(self, row.entity)
        teams[row.entity.id].add_assessment_result(assessment_result)
      end
    end
    teams.values.sort
  end

  def places_to_points
    teams = {}
    for_results do |result, result_rows, ranks|
      result_rows.each do |row|
        points = ranks[row]
        assessment_result = Score::AssessmentResult.new(points, result.assessment, row.result_entry, row.entity, row)
        teams[row.entity.id] ||= Score::CompetitionResultRow.new(self, row.entity)
        teams[row.entity.id].add_assessment_result(assessment_result)
      end
    end
    for_results do |result, result_rows, ranks|
      next if result_rows.empty?
      points = ranks.values.max + 1
      teams.keys.each do |team_id|
        if teams[team_id].assessment_result_from(result.assessment).blank?
          assessment_result = Score::AssessmentResult.new(points, result.assessment, Score::ResultEntry.invalid, Team.find(team_id), nil)
          teams[team_id].add_assessment_result(assessment_result)
        end
      end
    end
    teams.values.sort
  end
end