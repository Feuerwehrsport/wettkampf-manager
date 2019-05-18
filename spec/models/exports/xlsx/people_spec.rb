require 'rails_helper'

RSpec.describe Exports::XLSX::People, type: :model do
  let(:index_xlsx) { described_class.perform([female], [male]) }
  let(:female) { create(:person, :female).decorate }
  let(:male) { create(:person, :male, :with_team).decorate }

  describe 'perform' do
    it 'creates xlsx' do
      expect(index_xlsx.bytestream).to start_with "PK\u0003"
      expect(index_xlsx.bytestream).to end_with "\u0000\u0000"
      expect(index_xlsx.bytestream.size).to be_within(100).of(4526)
    end
  end
end
