# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::RunsController, type: :controller, seed: :configured do
  let(:list_entry) { create(:score_list_entry) }
  let(:user) { create(:user, name: 'user', assessment_ids: list_entry.list.assessment_ids) }
  let(:admin) { User.first }

  %i[admin user].each do |user_symbol|
    context "when user is a #{user_symbol}" do
      before do
        allow(controller).to receive(:current_user).and_return(send(user_symbol))
      end

      describe 'GET edit' do
        it 'renders form' do
          get :edit, params: { list_id: list_entry.list_id, run: 1 }
          expect(response).to be_successful
        end
      end

      describe 'PATCH update' do
        it 'updates run' do
          patch :update, params: { list_id: list_entry.list_id, run: 1, score_run: {
            list_entries_attributes: { '1' => { track: list_entry.track, edit_second_time: '33.33' } },
          } }

          expect(response).to redirect_to score_list_path(list_entry.list)
          expect(list_entry.reload.second_time).to eq '33,33'
        end
      end
    end
  end
end
