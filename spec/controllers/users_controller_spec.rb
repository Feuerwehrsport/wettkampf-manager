# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller, seed: :configured, user: :logged_in do
  let(:user) { create(:user, name: 'other') }

  render_views

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates user' do
      expect do
        post :create, params: { user: { name: 'Other', password: 'secret', password_confirmation: 'secret' } }
        expect(response).to redirect_to user_path(User.last.id)
      end.to change(User, :count).by(1)
    end
  end

  describe 'GET show' do
    it 'renders form' do
      get :show, params: { id: user.id }
      expect(response).to redirect_to(action: :index)
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
      get :edit, params: { id: user.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH update' do
    it 'updates user' do
      patch :update, params: { id: user.id, user: { name: 'foo' } }
      expect(response).to redirect_to action: :show, id: user.id
    end
  end

  describe 'DELETE destroy' do
    before { user }

    it 'destroys user' do
      expect do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to action: :index
      end.to change(User, :count).by(-1)
    end
  end
end
