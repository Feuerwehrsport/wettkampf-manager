module Certificates::StorageSupport
  def get(position) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
    case position.key
    when :team_name
      entity.is_a?(TeamRelayDecorator) ? entity : entity.try(:team).try(:numbered_name)
    when :person_name
      entity
    when :person_bib_number
      entity.try(:bib_number)
    when :time_long
      result_entry.long_human_time(seconds: 'Sekunden', invalid: 'Ungültig')
    when :time_short
      result_entry.human_time
    when :time_without_seconds
      result_entry.human_time.gsub(/DN/, '-').delete('s').strip
    when :rank
      "#{result.place_for_row(self)}."
    when :rank_with_rank
      "#{result.place_for_row(self)}. Platz"
    when :rank_without_dot
      result.place_for_row(self)
    when :assessment
      result.assessment.try(:name).presence || result.assessment.try(:discipline)
    when :assessment_with_gender
      result.assessment
    when :gender
      result.assessment.try(:translated_gender)
    when :date
      h.l(result.try(:date).presence || Competition.one.date)
    when :place
      Competition.one.place
    when :competition_name
      Competition.one.name
    when :points
      points
    when :points_with_points
      t('.points', count: points)
    when :text
      position.text
    end
  end
end
