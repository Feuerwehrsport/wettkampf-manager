Imports::Person = Struct.new(:configuration, :data) do
  def import
    @person = ::Person.create!(
      last_name: data[:last_name],
      first_name: data[:first_name],
      gender: data[:gender],
      team: team,
      fire_sport_statistics_person: fssp,
    )
    data[:tag_names].each do |tag_name|
      tag = configuration.tags.find_by(target: :person, name: tag_name, use: true).try(:competition_tag)
      @person.tag_references.create!(tag: tag) if tag.present?
    end
    data[:assessment_participations].each do |participation|
      assessment = configuration.assessments.find_by(foreign_key: participation[:assessment_id]).try(:assessment)
      next if assessment.blank?

      AssessmentRequest.create!(
        entity: @person,
        assessment: assessment,
        assessment_type: participation[:assessment_type],
        single_competitor_order: participation[:single_competitor_order] || 0,
        group_competitor_order: participation[:group_competitor_order] || 0,
        competitor_order: participation[:competitor_order] || 0,
      )
    end
  end

  def team
    @team ||= begin
      team = configuration.teams.find { |t| t.foreign_key == data[:team_id] }.try(:competition_team)

      if team.blank? && data[:team_name].present?
        team = ::Team.create_with(
          disable_autocreate_assessment_requests: true,
          shortcut: data[:team_name].first(12),
          number: 1,
        ).find_or_create_by!(
          name: data[:team_name],
          gender: Genderable::GENDERS[data[:gender].to_sym],
        )
      end
      team
    end
  end

  def fssp
    @fssp ||= FireSportStatistics::Person.find_by(id: data[:statitics_person_id])
  end
end
