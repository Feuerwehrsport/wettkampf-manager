def create_score_list(result, entities)
  list = create :score_list, results: [result], assessments: [result.assessment]
  index = 1
  entities.each do |entity, time|
    index += 1
    args = { entity: entity, list: list, assessment: result.assessment, track: (index % 2) + 1, run: (index / 2).to_i }
    if time.nil?
      create(:score_list_entry, :result_invalid, args)
    else
      create(:score_list_entry, :result_valid, args.merge(time: time))
    end
  end
  list.reload
  list
end
