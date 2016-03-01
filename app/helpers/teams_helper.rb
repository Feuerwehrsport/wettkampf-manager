module TeamsHelper
  def index_export_data
    headline = [
      Team.human_attribute_name(:name),
      Team.human_attribute_name(:gender),
      Team.human_attribute_name(:people),
    ]
    @tags.each { |tag| headline.push(tag.to_s) }
    data = [headline]
    @teams.each do |team|
      line = [
        team.numbered_name,
        team.translated_gender,
        team.people.count,
      ]
      @tags.each { |tag| line.push(team.tags.include?(tag) ? 'X' : '') }
      data.push(line)
    end
    data
  end
end
