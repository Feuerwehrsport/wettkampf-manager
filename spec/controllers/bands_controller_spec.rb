# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BandsController, type: :controller, seed: :configured, user: :logged_in do
  let(:band) { create(:band) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates band' do
      expect do
        post :create, params: { band: {
          name: 'Männer', gender: 'male'
        } }
        expect(response).to redirect_to action: :show, id: Band.last.id
      end.to change(Band, :count).by(1)
    end
  end

  describe 'GET show' do
    it 'renders form' do
      get :show, params: { id: band }
      expect(response).to be_successful
    end
  end

  describe 'GET index' do
    it 'renders' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET edit' do
    it 'renders form' do
      get :edit, params: { id: band.id }
      expect(response).to be_successful
    end

    context 'when move up' do
      it 'redirects' do
        get :edit, params: { id: band.id, move: 'up' }
        expect(response).to redirect_to(action: :index)
      end
    end

    context 'when move down' do
      it 'redirects' do
        get :edit, params: { id: band.id, move: 'down' }
        expect(response).to redirect_to(action: :index)
      end
    end
  end

  describe 'PATCH update' do
    it 'updates band' do
      patch :update, params: { id: band.id, band: { name: 'foo' } }
      expect(response).to redirect_to action: :show, id: band.id
    end
  end

  describe 'DELETE destroy' do
    before { band }

    it 'destroys band' do
      expect do
        delete :destroy, params: { id: band.id }
        expect(response).to redirect_to action: :index
      end.to change(Band, :count).by(-1)
    end
  end
end
