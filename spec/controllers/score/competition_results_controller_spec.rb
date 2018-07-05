require 'rails_helper'

RSpec.describe Score::CompetitionResultsController, type: :controller, seed: :configured, user: :logged_in do
  let(:competition_result) { create(:score_competition_result) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    it 'creates competition_result' do
      expect do
        post :create, score_competition_result: { name: 'foo', gender: :female, result_type: :dcup }
        expect(response).to redirect_to action: :index
      end.to change(Score::CompetitionResult, :count).by(1)
    end
  end

  describe 'GET index' do
    it 'renders' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET edit' do
    it 'renders form' do
      get :edit, id: competition_result.id
      expect(response).to be_success
    end
  end

  describe 'PATCH update' do
    it 'updates competition_result' do
      patch :update, id: competition_result.id, score_competition_result: { name: 'foo' }
      expect(response).to redirect_to action: :index
    end
  end

  describe 'DELETE destroy' do
    before { competition_result }
    it 'destroys competition_result' do
      expect do
        delete :destroy, id: competition_result.id
        expect(response).to redirect_to action: :index
      end.to change(Score::CompetitionResult, :count).by(-1)
    end
  end
end
