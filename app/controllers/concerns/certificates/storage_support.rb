module Certificates::StorageSupport
  def get(position)
    case position.key
    when :team_name
      entity.try(:team).try(:numbered_name)
    when :person_name
      entity
    when :person_bib_number
      entity.try(:bib_number)
    when :time_long
      result_entry.long_human_time(seconds: 'Sekunden', invalid: 'Ungültig')
    when :time_short
      result_entry.human_time
    when :rank
      "#{result.place_for_row(self)}."
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
      # TODO
      nil
    when :text
      position.text
    end
  end
end
