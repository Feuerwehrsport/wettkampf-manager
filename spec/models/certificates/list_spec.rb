require 'rails_helper'

RSpec.describe Certificates::List, type: :model do
  let(:template) { create(:certificates_template) }
  let(:result) { create(:score_result) }
  let(:competition_result) { create(:score_competition_result) }

  describe 'validation' do
    it do
      instance = described_class.new(template_id: template.id)
      expect(instance).not_to be_valid

      instance = described_class.new(template_id: template.id, score_result_id: result.id)
      expect(instance).to be_valid

      instance = described_class.new(template_id: template.id, score_result_id: result.id,
                                     group_score_result_id: result.id)
      expect(instance).not_to be_valid

      instance = described_class.new(template_id: template.id, group_score_result_id: result.id)
      expect(instance).to be_valid

      instance = described_class.new(template_id: template.id, competition_result_id: competition_result.id)
      expect(instance).to be_valid
    end
  end
end
