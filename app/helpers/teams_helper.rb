module TeamsHelper
  def index_export_data
    data = [[
      Team.human_attribute_name(:name),
      Team.human_attribute_name(:gender),
      Team.human_attribute_name(:people),
    ]]
    @teams.each do |team|
      data.push([
        team.numbered_name,
        team.translated_gender,
        team.people.count,
      ])
    end
    data
  end
end
