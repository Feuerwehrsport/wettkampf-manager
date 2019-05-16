#  move_score_list GET    /score/lists/:id/move(.:format)                     score/lists#move
#  select_entity_score_list GET    /score/lists/:id/select_entity(.:format)            score/lists#select_entity
# destroy_entity_score_list GET    /score/lists/:id/destroy_entity/:entry_id(.:format) score/lists#destroy_entity
#     edit_times_score_list GET    /score/lists/:id/edit_times(.:format)               score/lists#edit_times

require 'rails_helper'

RSpec.describe Score::ListsController, type: :controller, seed: :configured, user: :logged_in do
  let(:list) { create(:score_list) }
  let(:assessment) { create(:assessment) }

  describe 'GET index' do
    it 'renders' do
      get :index
      expect(response).to be_success
      expect(assigns(:tags)).to eq []
    end
  end

  describe 'GET edit_times' do
    it 'renders' do
      get :edit_times, id: list.id
      expect(response).to be_success
    end
  end

  describe 'GET select_entity' do
    it 'renders' do
      xhr :get, :select_entity, id: list.id
      expect(response).to be_success
    end
  end

  describe 'GET destroy_entity' do
    it 'renders' do
      xhr :get, :destroy_entity, id: list.id, entry_id: 1
      expect(response).to be_success
    end
  end

  describe 'GET show' do
    it 'renders' do
      get :show, id: list.id
      expect(response).to be_success
      expect(assigns(:tags)).to eq []
    end

    context 'when pdf requested' do
      it 'sends pdf' do
        get :show, id: list.id, format: :pdf
        expect(response).to be_success
        expect(response.headers['Content-Type']).to eq Mime::PDF
        expect(response.headers['Content-Disposition']).to eq 'inline; filename="hakenleitersteigen-manner-lauf-1.pdf"'
      end
    end

    context 'when xlsx requested' do
      it 'sends xlsx' do
        get :show, id: list.id, format: :xlsx
        expect(response).to be_success
        expect(response.headers['Content-Type']).to eq Mime::XLSX
        expect(response.headers['Content-Disposition']).to eq(
          'attachment; filename="hakenleitersteigen-manner-lauf-1.xlsx"',
        )
      end
    end
  end

  describe 'GET edit' do
    it 'renders form' do
      get :edit, id: list.id
      expect(response).to be_success
      expect(assigns(:tags)).to eq []
    end
  end

  describe 'PATCH update' do
    it 'updates list' do
      patch :update, id: list.id, score_list: { name: 'foo' }
      expect(response).to redirect_to action: :show, id: list.id
      expect(assigns(:tags)).to eq []
    end
  end

  describe 'DELETE destroy' do
    before { list }
    it 'destroys list' do
      expect do
        delete :destroy, id: list.id
        expect(response).to redirect_to action: :index
      end.to change(Score::List, :count).by(-1)
      expect(assigns(:tags)).to eq []
    end
  end
end
