# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FireSportStatistics::API::Get, type: :model do
  let(:import) { described_class.new }
  let(:result) do
    [
      { 'team_id' => 193, 'name' => 'FF Friedersdorf / OL', 'shortcut' => 'Friedersdorf / OL' },
      { 'team_id' => 193, 'name' => 'FF Friedersdorf/OL', 'shortcut' => 'Friedersdorf/OL' },
    ].map { |e| OpenStruct.new e }
  end

  describe '.fetch' do
    it 'returns array of open structs', vcr: true do
      expect(import.fetch(:team_spellings)).to eq result
    end
  end

  describe '#fetch' do
    it 'delegates to instance' do
      expect_any_instance_of(described_class).to receive(:fetch).with(:foo, nil).and_return(:bar)
      expect(described_class.fetch(:foo)).to eq :bar
    end
  end
end
