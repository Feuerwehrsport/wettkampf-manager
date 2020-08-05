# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListEntry, type: :model do
  let(:score_list) { build_stubbed :score_list }
  let(:score_list_entry) { build :score_list_entry, list: score_list }

  describe 'validation' do
    context 'when track count' do
      it 'validates track count from list' do
        expect(score_list_entry).to be_valid
        score_list_entry.track = 5
        expect(score_list_entry).not_to be_valid
        expect(score_list_entry).to have(1).errors_on(:track)
      end
    end
  end
end
