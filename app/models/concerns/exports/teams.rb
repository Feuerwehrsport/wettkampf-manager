# frozen_string_literal: true

module Exports::Teams
  def index_export_data(collection, full: false)
    headline = [Team.human_attribute_name(:name)]
    headline.push('BL') if Competition.one.federal_states?
    headline.push(Team.human_attribute_name(:band), 'Wettkä.')
    headline.push('Los') if Competition.one.lottery_numbers?
    headline.push(Team.human_attribute_name(:shortcut)) if full
    tags.each { |tag| headline.push(tag.to_s) }
    data = [headline]

    collection.each do |team|
      pc = team.people.count
      line = [team.numbered_name]
      line.push(team.federal_state.try(:shortcut)) if Competition.one.federal_states?
      line.push(team.band.name, pc.zero? ? '-' : pc)
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
