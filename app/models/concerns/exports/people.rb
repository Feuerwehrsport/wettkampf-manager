# frozen_string_literal: true

module Exports::People
  def index_export_data(band, collection)
    return [] if collection.empty?

    assessments = Assessment.requestable_for_person(band).map(&:decorate)
    headline = []
    headline.push('Nr.') if Competition.one.show_bib_numbers?
    headline.push('Nachname', 'Vorname', 'Mannschaft')
    tags.each { |tag| headline.push(tag.to_s) }
    assessments.each { |assessment| headline.push(assessment.discipline.to_short) }
    data = [headline]

    collection.each do |person|
      line = []
      line.push(person.bib_number) if Competition.one.show_bib_numbers?
      line.push(person.last_name, person.first_name, person.team&.shortcut_name)
      tags.each { |tag| line.push(person.tags.include?(tag) ? 'X' : '') }
      assessments.each do |assessment|
        request = person.request_for(assessment.object)
        line.push(request.present? ? t("assessment_types.#{request.assessment_type}_short") : '')
      end
      data.push(line)
    end
    data
  end

  def tags
    @tags ||= PersonTag.all.decorate
  end
end
