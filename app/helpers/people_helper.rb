module PeopleHelper
  def specific_request(assessment) 
    request = @person.requests.find_or_initialize_by(assessment: assessment)
    request.assessment_type = :no_request unless request.persisted?
    request
  end
end
