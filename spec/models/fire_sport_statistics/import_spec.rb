# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FireSportStatistics::Import, type: :model do
  describe 'process bar' do
    it 'prints lines' do
      expect(FireSportStatistics::API::Get).to receive(:fetch).with(:bar, nil).and_return([:foo])

      expect do
        described_class.new.send(:fetch, :bar) { |arg| }
      end.to output("bar: 0%\rbar: 0%\rbar: 100%\r\n").to_stdout
    end
  end
end
