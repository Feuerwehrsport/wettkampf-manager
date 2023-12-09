# frozen_string_literal: true

module Certificates::StorageSupport
  def get(position)
    case position.key
    when :team_name
      entity.is_a?(TeamRelayDecorator) ? entity : entity.try(:team).try(:numbered_name)
    when :person_name
      entity
    when :person_bib_number
      entity.try(:bib_number)
    when :time_long
      result_entry.long_human_time(seconds: 'Sekunden', invalid: 'Ungültig') if respond_to?(:result_entry)
    when :time_very_long
      storage_support_time_very_long
    when :time_other_long
      storage_support_time_very_long('belegte ')
    when :time_short
      result_entry.long_human_time(seconds: 's', invalid: 'D') if respond_to?(:result_entry)
    when :time_without_seconds
      result_entry.human_time.gsub(/[DN]/, '-').delete('s').strip if respond_to?(:result_entry)
    when :rank
      "#{result.place_for_row(self)}."
    when :rank_with_rank
      "#{result.place_for_row(self)}. Platz"
    when :rank_with_rank_2
      "den #{result.place_for_row(self)}. Platz"
    when :rank_without_dot
      result.place_for_row(self)
    when :assessment
      result.assessment.try(:name).presence || result.assessment.try(:discipline) if result.respond_to?(:assessment)
    when :result_name
      result.to_s
    when :assessment_with_gender
      result.assessment if result.respond_to?(:assessment)
    when :gender
      storage_support_band
    when :date
      h.l(result.try(:date).presence || Competition.one.date)
    when :place
      Competition.one.place
    when :competition_name
      Competition.one.name
    when :points
      points if respond_to?(:points)
    when :points_with_points
      t('certificates.lists.export.points', count: points) if respond_to?(:points)
    when :text
      position.text
    end
  end

  private

  def storage_support_time_very_long(prefix = '')
    return unless respond_to?(:result_entry)

    if result_entry.result_valid?
      "#{prefix}mit einer Zeit von #{result_entry.long_human_time(seconds: 'Sekunden', invalid: 'Ungültig')}"
    else
      "#{prefix}mit einer ungültigen Zeit"
    end
  end

  def storage_support_band
    if result.respond_to?(:band)
      result&.band&.name
    elsif result.respond_to?(:assessment)
      result.assessment&.band&.name
    end
  end
end
