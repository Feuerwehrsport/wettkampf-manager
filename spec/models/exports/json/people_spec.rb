# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::JSON::People, type: :model do
  let(:export) { described_class.perform(Person.all) }
  let!(:female) { create(:person, :female).decorate }
  let!(:male) { create(:person, :male, :with_team).decorate }

  describe 'perform' do
    it 'creates export' do
      expect(export.bytestream).to eq({
        bands: [
          {
            name: 'Frauen',
            gender: 'female',
            people: [%w[Nachname Vorname Mannschaft], ['Meier', 'Alfred', nil]],
          },
          {
            name: 'Männer',
            gender: 'male',
            people: [%w[Nachname Vorname Mannschaft], ['Meier', 'Alfred', 'Team MV']],
          },
        ],
      }.to_json)

      expect(export.filename).to eq 'wettkaempfer.json'
    end
  end
end
