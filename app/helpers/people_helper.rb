module PeopleHelper
  def specific_request(assessment) 
    request = @person.requests.find_or_initialize_by(assessment: assessment)
    request.assessment_type = :no_request unless request.persisted?
    request
  end

  def index_export_data(collection)
    assessments = Assessment.requestable_for(collection.first).map(&:decorate)
    headline = []
    headline.push("Nr.") if Competition.one.show_bib_numbers?
    headline.push(
      "Vorname",
      "Nachname",
      Person.human_attribute_name(:team),
      "U20",
    )
    data = [headline]
    assessments.each { |assessment| data.first.push(assessment.discipline.to_short) }
    
    collection.each do |person|
      line = []
      line.push(person.bib_number) if Competition.one.show_bib_numbers?
      line.push(
        person.first_name,
        person.last_name,
        person.team.to_s,
        person.youth ? 'X' : '',
      )
      data.push(line)
      assessments.each do |assessment|
        request = person.request_for(assessment.object)
        if request.present?
          data.last.push(t("assessment_types.#{request.assessment_type}_short"))
        else
          data.last.push("")
        end
      end
    end
    data
  end
end
