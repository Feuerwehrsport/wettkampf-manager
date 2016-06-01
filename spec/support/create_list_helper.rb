def create_score_list result, entities
  list = create :score_list, results: [result], assessments: [result.assessment]
  entities.each do |entity, time|
    if time.nil?
      create :score_list_entry, :result_invalid, entity: entity, list: list, assessment: result.assessment
    else
      entry = create :score_list_entry, :result_valid, entity: entity, list: list, assessment: result.assessment, time: time
    end
  end
  list.reload
  list
end