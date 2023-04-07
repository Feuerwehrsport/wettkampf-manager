# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssessmentsController, type: :controller, seed: :configured do
  let(:assessment) { create(:assessment) }
  let(:discipline) { create(:fire_relay) }
  let(:band) { create(:band) }

  describe 'GET new', user: :logged_in do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create', user: :logged_in do
    it 'creates assessment' do
      expect do
        post :create, params: { assessment: {
          discipline_id: discipline.id,
          band_id: band.id,
        } }
        expect(response).to redirect_to action: :show, id: Assessment.last.id
      end.to change(Assessment, :count).by(1)
    end
  end

  describe 'GET show' do
    it 'renders form' do
      get :show, params: { id: assessment }
      expect(response).to be_successful
    end
  end

  describe 'GET index' do
    it 'renders' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET edit', user: :logged_in do
    it 'renders form' do
      get :edit, params: { id: assessment.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH update', user: :logged_in do
    it 'updates assessment' do
      patch :update, params: { id: assessment.id, assessment: { name: 'foo' } }
      expect(response).to redirect_to action: :show, id: assessment.id
    end
  end

  describe 'DELETE destroy', user: :logged_in do
    before { assessment }

    it 'destroys assessment' do
      expect do
        delete :destroy, params: { id: assessment.id }
        expect(response).to redirect_to action: :index
      end.to change(Assessment, :count).by(-1)
    end
  end
end
