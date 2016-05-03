module Imports
  class Person < Struct.new(:configuration, :data)
    def import
      team = configuration.teams.find { |team| team.foreign_key == data[:team_id] }.try(:competition_team)
      fssp = FireSportStatistics::Person.find_by(id: data[:statitics_person_id])
      @person = ::Person.create!(last_name: data[:last_name], first_name: data[:first_name], gender: data[:gender], team: team, fire_sport_statistics_person: fssp)
      data[:tag_names].each do |tag_name|
        tag = configuration.tags.find_by(target: :person, name: tag_name, use: true).try(:competition_tag)
        @person.tag_references.create!(tag: tag) if tag.present?
      end
      data[:assessment_participations].each do |participation|
        assessment = configuration.assessments.find_by(foreign_key: participation[:assessment_id]).try(:assessment)
        if assessment.present?
          AssessmentRequest.create!(
            entity: @person, 
            assessment: assessment, 
            assessment_type: participation[:assessment_type],
            single_competitor_order: participation[:single_competitor_order],
            group_competitor_order: participation[:group_competitor_order],
          )
        end
      end
    end
  end
end