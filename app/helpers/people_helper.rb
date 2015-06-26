module PeopleHelper
  def specific_request(assessment) 
    request = @person.requests.find_or_initialize_by(assessment: assessment)
    request.assessment_type = :no_request unless request.persisted?
    request
  end

  def index_export_data(collection)
    assessments = Assessment.requestable_for(collection.first).map(&:decorate)
    data = [[
      "Vorname",
      "Nachname",
      Person.human_attribute_name(:team),
      "U20",
    ]]
    assessments.each { |assessment| data.first.push(assessment.discipline.to_short) }
    
    collection.each do |person|
      data.push([
        person.first_name,
        person.last_name,
        person.team.to_s,
        person.youth ? 'X' : '',
      ])
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
