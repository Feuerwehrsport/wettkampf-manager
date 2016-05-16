module Score
  class CompetitionResult < ActiveRecord::Base
    has_many :assessments, foreign_key: :score_competition_result_id
    has_many :results, -> { where(score_results: { group_assessment: true }) }, through: :assessments
    enum gender: { female: 0, male: 1 }
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

    def dcup
      teams = {}
      results.each do |result|
        discipline = result.assessment.discipline
        if discipline.single_discipline?
          result_rows = GroupResult.new(result).rows
        else
          result_rows = result.group_result_rows
        end

        points = 11
        current_assessment_results = []
        result_rows.each do |row|
          points -= 1 if points > 0
          assessment_result = AssessmentResult.new(row.competition_result_valid? ? points : 0, result.assessment, row.time, row.entity, row)
          teams[row.entity.id] = CompetitionResultRow.new(self, row.entity) if teams[row.entity.id].nil?
          teams[row.entity.id].add_assessment_result(assessment_result)
          current_assessment_results.push(assessment_result)
        end

        loop do
          assessment_result = current_assessment_results.pop
          break if assessment_result.blank?
          break if assessment_result.points == 0 && assessment_result.row.competition_result_valid?
          break if assessment_result.row.valid?
          assessment_result.points = points
        end
      end
      teams.values.sort
    end

    def places_to_points
      teams = {}
      results.each do |result|
        discipline = result.assessment.discipline
        if discipline.single_discipline?
          result_rows = GroupResult.new(result).rows
        else 
          result_rows = result.group_result_rows
        end

        points = 0
        current_assessment_results = []
        result_rows.each do |row|
          points += 1
          assessment_result = AssessmentResult.new(points, result.assessment, row.time, row.entity, row)
          teams[row.entity.id] = CompetitionResultRow.new(self, row.entity) if teams[row.entity.id].nil?
          teams[row.entity.id].add_assessment_result(assessment_result)
          current_assessment_results.push(assessment_result)
        end

        max_points = current_assessment_results.count
        max_invalid_points = current_assessment_results.select { |a| a.row.competition_result_valid? }.count
        loop do
          assessment_result = current_assessment_results.pop
          break if assessment_result.blank?
          break if assessment_result.row.valid?
          if !assessment_result.row.competition_result_valid?
            assessment_result.points = max_points
          elsif !assessment_result.row.valid?
            assessment_result.points = max_invalid_points
          end
        end
      end
      teams.values.sort
    end
  end
end