# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::JSON::Teams, type: :model do
  let(:export) { described_class.perform([team]) }
  let(:team) { create(:team).decorate }

  describe 'perform' do
    it 'creates export' do
      expect(export.bytestream).to eq(
        { teams: [['Name', 'BL', 'Geschlecht', 'Wettkä.'], ['Mecklenburg-Vorpommern', nil, 'Männer', '-']] }.to_json,
      )

      expect(export.filename).to eq 'mannschaften.json'
    end
  end
end
