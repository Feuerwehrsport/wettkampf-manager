# frozen_string_literal: true

#  move_score_list GET    /score/lists/:id/move(.:format)                     score/lists#move
#  select_entity_score_list GET    /score/lists/:id/select_entity(.:format)            score/lists#select_entity
# destroy_entity_score_list GET    /score/lists/:id/destroy_entity/:entry_id(.:format) score/lists#destroy_entity
#     edit_times_score_list GET    /score/lists/:id/edit_times(.:format)               score/lists#edit_times

require 'rails_helper'

RSpec.describe Score::ListsController, type: :controller, seed: :configured do
  let(:list) { create(:score_list) }
  let(:assessment) { create(:assessment) }

  let(:user) { create(:user, name: 'user', assessment_ids: list.assessment_ids) }
  let(:admin) { User.first }

  %i[admin user].each do |user_symbol|
    context "when user is a #{user_symbol}" do
      before do
        allow(controller).to receive(:current_user).and_return(send(user_symbol))
      end

      describe 'GET index' do
        it 'renders' do
          get :index
          expect(response).to be_successful
          expect(assigns(:tags)).to eq []
        end
      end

      describe 'GET edit_times' do
        it 'renders' do
          get :edit_times, params: { id: list.id }
          expect(response).to be_successful
        end
      end

      describe 'GET select_entity' do
        it 'renders' do
          get :select_entity, xhr: true, params: { id: list.id }
          expect(response).to be_successful
        end
      end

      describe 'GET destroy_entity' do
        it 'renders' do
          get :destroy_entity, xhr: true, params: { id: list.id, entry_id: 1 }
          expect(response).to be_successful
        end
      end

      describe 'GET show' do
        it 'renders' do
          get :show, params: { id: list.id }
          expect(response).to be_successful
          expect(assigns(:tags)).to eq []
        end

        context 'when pdf requested' do
          it 'sends pdf' do
            get :show, params: { id: list.id, format: :pdf }
            expect(response).to be_successful
            expect(response.headers['Content-Type']).to eq Mime[:pdf]
            expect(response.headers['Content-Disposition']).to eq(
              'inline; filename="hakenleitersteigen-manner-lauf-1.pdf"',
            )
          end
        end

        context 'when xlsx requested' do
          it 'sends xlsx' do
            get :show, params: { id: list.id, format: :xlsx }
            expect(response).to be_successful
            expect(response.headers['Content-Type']).to eq Mime[:xlsx]
            expect(response.headers['Content-Disposition']).to eq(
              'attachment; filename="hakenleitersteigen-manner-lauf-1.xlsx"',
            )
          end
        end
      end

      describe 'GET edit' do
        it 'renders form' do
          get :edit, params: { id: list.id }
          expect(response).to be_successful
          expect(assigns(:tags)).to eq []
        end
      end

      describe 'PATCH update' do
        it 'updates list' do
          patch :update, params: { id: list.id, score_list: { name: 'foo' } }
          expect(response).to redirect_to action: :show, id: list.id
          expect(assigns(:tags)).to eq []
        end

        context 'when edit_times edited' do
          let(:entry) { create(:score_list_entry, list: list) }

          context 'when last_update_timestamp is wrong' do
            it 'renders again' do
              patch :update, params: { id: list.id, edit_times: 1, score_list: { entries_attributes: {
                '0' => {
                  track: '1',
                  last_update_timestamp: '1661506594',
                  edit_second_time: '19.86',
                  result_type: 'valid',
                  id: entry.id,
                },
              } } }
              expect(response).to be_successful
              expect(response).to render_template 'edit_times'
            end
          end

          context 'when last_update_timestamp is correct' do
            it 'redirects' do
              patch :update, params: { id: list.id, edit_times: 1, score_list: { entries_attributes: {
                '0' => {
                  track: '1',
                  last_update_timestamp: entry.updated_at.to_i.to_s,
                  edit_second_time: '19.86',
                  result_type: 'valid',
                  id: entry.id,
                },
              } } }
              expect(response).to redirect_to action: :show, id: list.id
            end
          end
        end
      end
    end
  end

  describe 'DELETE destroy', user: :logged_in do
    before { list }

    it 'destroys list' do
      expect do
        delete :destroy, params: { id: list.id }
        expect(response).to redirect_to action: :index
      end.to change(Score::List, :count).by(-1)
      expect(assigns(:tags)).to eq []
    end
  end
end
