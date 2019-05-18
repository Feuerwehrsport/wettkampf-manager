require 'rails_helper'

RSpec.describe Exports::JSON::People, type: :model do
  let(:export) { described_class.perform([female], [male]) }
  let(:female) { create(:person, :female).decorate }
  let(:male) { create(:person, :male, :with_team).decorate }

  describe 'perform' do
    it 'creates export' do
      expect(export.bytestream).to eq({
        female: [%w[Nachname Vorname Mannschaft], ['Meier', 'Alfred', nil]],
        male: [%w[Nachname Vorname Mannschaft], ['Meier', 'Alfred', 'Team MV']],
      }.to_json)
    end
  end
end
