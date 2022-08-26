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

    context 'when last_update_timestamp given' do
      let(:score_list_entry) { build_stubbed :score_list_entry, list: score_list }

      it 'checks it is the same' do
        expect(score_list_entry.last_update_timestamp).to be_instance_of(Integer)

        score_list_entry.last_update_timestamp = 123
        expect(score_list_entry).not_to be_valid
        expect(score_list_entry.errors).to include :last_update_timestamp

        score_list_entry.last_update_timestamp = score_list_entry.updated_at.to_i
        expect(score_list_entry).to be_valid

        score_list_entry.last_update_timestamp = nil
        expect(score_list_entry).to be_valid
      end
    end
  end
end
