module Imports
  class Team < Struct.new(:configuration, :data)
    def import
      number = [1, data[:team_number].to_i].max
      fsst = FireSportStatistics::Person.find_by(external_id: data[:statitics_team_id])
      @team = ::Team.create!(name: data[:name], gender: data[:gender], number: number, shortcut: data[:shortcut].first(12), disable_autocreate_assessment_requests: true)
      data[:tag_names].each do |tag_name|
        tag = configuration.tags.find_by(target: :team, name: tag_name, use: true).try(:competition_tag)
        @team.tag_references.create!(tag: tag) if tag.present?
      end
      data[:assessments].each do |assessment_foreign_key|
        assessment = configuration.assessments.find_by(foreign_key: assessment_foreign_key).try(:assessment)
        AssessmentRequest.create!(entity: @team, assessment: assessment) if assessment.present?
      end
    end

    def foreign_key
      data[:id]
    end

    def competition_team
      @team
    end
  end
end