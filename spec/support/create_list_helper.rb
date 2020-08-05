# frozen_string_literal: true

def create_score_list(result, entities)
  list = create :score_list, results: [result], assessments: [result.assessment]
  index = 1
  entities.each do |entity, time|
    index += 1
    args = { entity: entity, list: list, assessment: result.assessment, track: (index % 2) + 1, run: (index / 2).to_i }
    if time == :waiting
      create(:score_list_entry, args)
    elsif time.nil?
      create(:score_list_entry, :result_invalid, args)
    else
      create(:score_list_entry, :result_valid, args.merge(time: time))
    end
  end
  list.reload
  list
end

def create_assessment_request(entity, assessment, group_order, single_order = 0, assessment_type = :group_competitor)
  create(:assessment_request,
         assessment: assessment,
         entity: entity,
         group_competitor_order: group_order,
         single_competitor_order: single_order,
         assessment_type: assessment_type)
end
