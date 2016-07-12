class Imports::Team < Struct.new(:configuration, :data)
  def import
    number = [1, data[:team_number].to_i].max
    fsst = FireSportStatistics::Team.find_by(id: data[:statitics_team_id])
    @team = ::Team.create!(
      name: data[:name], 
      gender: data[:gender], 
      number: number, 
      shortcut: data[:shortcut].first(12), 
      disable_autocreate_assessment_requests: true, 
      fire_sport_statistics_team: fsst,
      federal_state: FederalState.find_by_shortcut(data[:federal_state]),
    )
    data[:tag_names].each do |tag_name|
      tag = configuration.tags.find_by(target: :team, name: tag_name, use: true).try(:competition_tag)
      @team.tag_references.create!(tag: tag) if tag.present?
    end
    data[:assessments].each do |assessment_foreign_key|
      assessment = configuration.assessments.find_by(foreign_key: assessment_foreign_key).try(:assessment)
      if assessment.present?
        count = assessment.fire_relay? ? 2 : 1
        AssessmentRequest.create!(entity: @team, assessment: assessment, relay_count: count)
      end
    end
  end

  def foreign_key
    data[:id]
  end

  def competition_team
    @team
  end
end