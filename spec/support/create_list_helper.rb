def create_score_list result, entities
  list = create :score_list, result_ids: [result.id]
  entities.each do |entity, time|
    if time.nil?
      create :score_list_entry, :result_invalid, entity: entity, list: list
    else
      entry = create :score_list_entry, :result_valid, entity: entity, list: list
      create :score_electronic_time, list_entry: entry, time: time
    end
  end
  list
end