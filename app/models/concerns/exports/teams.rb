module Exports::Teams
  def index_export_data(collection, full: false)
    headline = [
      Team.human_attribute_name(:name),
      'BL',
      Team.human_attribute_name(:gender),
      'Wettkä.',
    ]
    headline.push('Los') if Competition.one.lottery_numbers?
    headline.push(Team.human_attribute_name(:shortcut)) if full
    tags.each { |tag| headline.push(tag.to_s) }
    data = [headline]

    collection.each do |team|
      pc = team.people.count
      line = [
        team.numbered_name,
        team.federal_state.try(:shortcut),
        team.translated_gender,
        pc.zero? ? '-' : pc,
      ]
      line.push(team.lottery_number) if Competition.one.lottery_numbers?
      line.push(team.shortcut) if full
      tags.each { |tag| line.push(team.tags.include?(tag) ? 'X' : '') }
      data.push(line)
    end
    data
  end

  protected

  def tags
    @tags ||= TeamTag.all.decorate
  end
end
