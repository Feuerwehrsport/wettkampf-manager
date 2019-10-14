require 'rails_helper'

RSpec.describe Score::CompetitionResultsController, type: :controller, seed: :configured, user: :logged_in do
  let(:competition_result) { create(:score_competition_result) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates competition_result' do
      expect do
        post :create, params: { score_competition_result: { name: 'foo', gender: :female, result_type: :dcup } }
        expect(response).to redirect_to action: :index
      end.to change(Score::CompetitionResult, :count).by(1)
    end
  end

  describe 'GET index' do
    it 'renders' do
      get :index
      expect(response).to be_successful
    end

    context 'when pdf requested' do
      it 'sends pdf' do
        get :index, format: :pdf
        expect(response).to be_successful
        expect(response.headers['Content-Type']).to eq Mime[:pdf]
        expect(response.headers['Content-Disposition']).to eq 'inline; filename="gesamtwertungen.pdf"'
      end
    end

    context 'when xlsx requested' do
      it 'sends xlsx' do
        get :index, format: :xlsx
        expect(response).to be_successful
        expect(response.headers['Content-Type']).to eq Mime[:xlsx]
        expect(response.headers['Content-Disposition']).to eq 'attachment; filename="gesamtwertungen.xlsx"'
      end
    end
  end

  describe 'GET edit' do
    it 'renders form' do
      get :edit, params: { id: competition_result.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH update' do
    it 'updates competition_result' do
      patch :update, params: { id: competition_result.id, score_competition_result: { name: 'foo' } }
      expect(response).to redirect_to action: :index
    end
  end

  describe 'DELETE destroy' do
    before { competition_result }

    it 'destroys competition_result' do
      expect do
        delete :destroy, params: { id: competition_result.id }
        expect(response).to redirect_to action: :index
      end.to change(Score::CompetitionResult, :count).by(-1)
    end
  end
end
