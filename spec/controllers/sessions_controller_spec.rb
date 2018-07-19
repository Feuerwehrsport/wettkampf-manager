require 'rails_helper'

RSpec.describe SessionsController, type: :controller, seed: :configured do
  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    it 'logges in' do
      post :create, user: { name: 'admin', password: 'admin' }
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq User.first.id
    end

    context 'when password is wrong' do
      it 'failes' do
        post :create, user: { name: 'admin', password: 'wrong' }
        expect(response).to be_success
        expect(session[:user_id]).to eq nil
      end
    end
  end

  describe 'DELETE destroy' do
    it 'logges out' do
      delete :destroy, {}, user_id: User.first.id
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil
    end
  end
end
