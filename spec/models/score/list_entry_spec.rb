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

    context 'when edit_second_time_before given' do
      let(:score_list_entry) { create :score_list_entry, list: score_list, edit_second_time: '22.88' }

      it 'checks it is the same' do
        expect(score_list_entry.edit_second_time_before).to eq '22.88'
        score_list_entry.edit_second_time = '22.89'

        score_list_entry.edit_second_time_before = '11.33'
        expect(score_list_entry).not_to be_valid
        expect(score_list_entry.errors).to include :changed_while_editing

        score_list_entry.edit_second_time_before = '22.88'
        expect(score_list_entry).to be_valid

        score_list_entry.edit_second_time_before = nil
        expect(score_list_entry).to be_valid
      end
    end
  end
end
