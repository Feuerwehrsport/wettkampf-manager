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
    )
    @tags.each { |tag| headline.push(tag.to_s) }
    assessments.each { |assessment| headline.push(assessment.discipline.to_short) }
    data = [headline]
    
    collection.each do |person|
      line = []
      line.push(person.bib_number) if Competition.one.show_bib_numbers?
      line.push(
        person.first_name,
        person.last_name,
        person.team.to_s,
      )
      @tags.each { |tag| line.push(person.tags.include?(tag) ? 'X' : '') }
      assessments.each do |assessment|
        request = person.request_for(assessment.object)
        if request.present?
          line.push(t("assessment_types.#{request.assessment_type}_short"))
        else
          line.push("")
        end
      end
      data.push(line)
    end
    data
  end
end
