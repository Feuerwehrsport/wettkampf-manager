# frozen_string_literal: true

Imports::Team = Struct.new(:configuration, :data) do
  def import
    number = [1, data[:team_number].to_i].max
    fsst = FireSportStatistics::Team.find_by(id: data[:statitics_team_id])
    @team = ::Team.create!(
      name: data[:name],
      gender: data[:gender],
      number: number,
      shortcut: clean_and_cut_shortcut(data[:shortcut]),
      disable_autocreate_assessment_requests: true,
      fire_sport_statistics_team: fsst,
      federal_state: FederalState.find_by(shortcut: data[:federal_state]),
    )
    data[:tag_names].each do |tag_name|
      tag = configuration.tags.find_by(target: :team, name: tag_name, use: true).try(:competition_tag)
      @team.tag_references.create!(tag: tag) if tag.present?
    end
    data[:assessments].each do |assessment_foreign_key|
      assessment = configuration.assessments.find_by(foreign_key: assessment_foreign_key).try(:assessment)
      if assessment.present? && assessment.discipline.group_discipline?
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

  protected

  def clean_and_cut_shortcut(long)
    loop do
      before = long
      long = long.gsub(/\AFF\s/, '')
      long = long.gsub(/\ABF\s/, '')
      long = long.gsub(/\AOB\s/, '')
      long = long.gsub(/\ATeam\s/, '')
      long = long.gsub(/\AWettkampfteam\s/i, '')
      long = long.gsub(/\AWettkampfgruppe\s/i, '')
      long = long.gsub(/Berufsfeuerwehr/i, '')
      long = long.gsub(/Gruppe/i, '')
      long = long.gsub(/Wettkampf/i, '')
      long = long.gsub(/Freiwillige/i, '')
      long = long.gsub(/Feuerwehr/i, '')
      long = long.gsub(/Ostseebad/i, '')
      long = long.gsub(/\s-\s/, '-')
      long = long.strip
      break if before == long
    end
    long.first(12)
  end
end
