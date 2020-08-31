# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Series::Cup, type: :model do
  describe '#create_today!' do
    let!(:round) { create(:series_round) }

    it 'creates a fake cup for current competition' do
      expect do
        described_class.create_today!
      end.to change(described_class, :count).by(1)
      cup = described_class.last
      expect(cup.id).to eq 99_999_001
    end
  end
end
