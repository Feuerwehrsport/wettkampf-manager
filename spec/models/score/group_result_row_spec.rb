require 'rails_helper'

RSpec.describe Score::GroupResultRow, type: :model do
  let(:team) { build_stubbed :team }
  let(:group_result_row) { described_class.new(team, 2, 4) }
  let(:score_result_row) { build(:good_score_result_row) }
  
  describe "" do
    it "" do
      score_result_row
      expect(group_result_row.time).to be_nil
      group_result_row.add_result_row(score_result_row)
      group_result_row.send(:calculate)
      expect(group_result_row.time).to be_nil

    end
  end
end
