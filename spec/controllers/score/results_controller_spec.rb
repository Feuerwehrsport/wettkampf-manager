# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ResultsController, type: :controller, seed: :configured, user: :logged_in do
  let(:result) { create(:score_result) }
  let(:assessment) { create(:assessment) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
      expect(assigns(:tags)).to eq []
    end
  end

  describe 'POST create' do
    it 'creates result' do
      expect do
        post :create, params: { score_result: { assessment_id: assessment.id } }
        expect(response).to redirect_to action: :show, id: Score::Result.last.id
      end.to change(Score::Result, :count).by(1)
      expect(assigns(:tags)).to eq []
    end
  end

  describe 'GET index' do
    it 'renders' do
      get :index
      expect(response).to be_successful
      expect(assigns(:tags)).to eq []
    end
  end

  describe 'GET show' do
    it 'renders' do
      get :show, params: { id: result.id }
      expect(response).to be_successful
      expect(assigns(:tags)).to eq []
    end

    context 'when pdf requested' do
      it 'sends pdf' do
        get :show, params: { id: result.id, format: :pdf }
        expect(response).to be_successful
        expect(response.headers['Content-Type']).to eq Mime[:pdf]
        expect(response.headers['Content-Disposition']).to eq 'inline; filename="hakenleitersteigen-manner.pdf"'
      end
    end

    context 'when xlsx requested' do
      it 'sends xlsx' do
        get :show, params: { id: result.id, format: :xlsx }
        expect(response).to be_successful
        expect(response.headers['Content-Type']).to eq Mime[:xlsx]
        expect(response.headers['Content-Disposition']).to eq 'attachment; filename="hakenleitersteigen-manner.xlsx"'
      end
    end
  end

  describe 'GET edit' do
    it 'renders form' do
      get :edit, params: { id: result.id }
      expect(response).to be_successful
      expect(assigns(:tags)).to eq []
      expect(assigns(:series_form)).to eq false
    end

    context 'when series form requested' do
      it 'renders form' do
        get :edit, params: { id: result.id, series: '1' }
        expect(response).to be_successful
        expect(assigns(:tags)).to eq []
        expect(assigns(:series_form)).to eq true
      end
    end
  end

  describe 'PATCH update' do
    it 'updates result' do
      patch :update, params: { id: result.id, score_result: { name: 'foo' } }
      expect(response).to redirect_to action: :show, id: result.id
      expect(assigns(:tags)).to eq []
    end
  end

  describe 'DELETE destroy' do
    before { result }

    it 'destroys result' do
      expect do
        delete :destroy, params: { id: result.id }
        expect(response).to redirect_to action: :index
      end.to change(Score::Result, :count).by(-1)
      expect(assigns(:tags)).to eq []
    end
  end
end
