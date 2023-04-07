Imports::Band = Struct.new(:configuration, :data, :position) do
  def band
    @band = Band.create_with(position: position).find_or_initialize_by(name: name, gender: gender)
  end

  def name
    data[:name]
  end

  def gender
    data[:gender]
  end

  def teams
    @teams ||= data[:teams].map { |t| Imports::Team.new(configuration, self, t) }
  end

  def people
    @people ||= data[:people].map { |t| Imports::Person.new(configuration, self, t) }
  end

  def assessments
    @assessments ||= data[:assessments].map { |t| Imports::Assessment.new(configuration, self, t) }
  end

  def person_tag_list
    data[:person_tag_list]
  end

  def team_tag_list
    data[:team_tag_list]
  end

  def import
    band.save!

    person_tag_list.each do |tag_name|
      tag = configuration.tags.find { |t| t.target == 'person' && t.name == tag_name }&.competition_tag
      band.tag_references.create!(tag: tag) if tag.present?
    end
    team_tag_list.each do |tag_name|
      tag = configuration.tags.find { |t| t.target == 'team' && t.name == tag_name }&.competition_tag
      band.tag_references.create!(tag: tag) if tag.present?
    end

    assessments.each(&:import)
    teams.each(&:import)
    people.each(&:import)
  end
end
