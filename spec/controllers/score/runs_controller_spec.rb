require 'rails_helper'

RSpec.describe Score::RunsController, type: :controller, seed: :configured, user: :logged_in do
  let(:list_entry) { create(:score_list_entry) }

  describe 'GET edit' do
    it 'renders form' do
      get :edit, list_id: list_entry.list_id, run: 1
      expect(response).to be_success
    end
  end

  describe 'PATCH update' do
    it 'updates run' do
      patch :update, list_id: list_entry.list_id, run: 1,
                     score_run: { list_entries_attributes: { '1' => { track: list_entry.track,
                                                                      edit_second_time: '33.33' } } }

      expect(response).to redirect_to score_list_path(list_entry.list)
      expect(list_entry.reload.second_time).to eq '33,33'
    end
  end
end
