require 'rails_helper'

RSpec.describe DisciplinesController, type: :controller, seed: :configured, user: :logged_in do
  let(:discipline) { create(:fire_relay) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates discipline' do
      expect do
        post :create, params: { discipline: { name: 'foo', type: 'Disciplines::ObstacleCourse', like_fire_relay: true } }
        expect(response).to redirect_to action: :show, id: Discipline.last.id
      end.to change(Discipline, :count).by(1)
    end
  end

  describe 'GET show' do
    it 'renders form' do
      get :show, params: { id: discipline }
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
      get :edit, params: { id: discipline.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH update' do
    it 'updates discipline' do
      patch :update, params: { id: discipline.id, discipline: { name: 'foo' } }
      expect(response).to redirect_to action: :show, id: discipline.id
    end
  end

  describe 'DELETE destroy' do
    before { discipline }

    it 'destroys discipline' do
      expect do
        delete :destroy, params: { id: discipline.id }
        expect(response).to redirect_to action: :index
      end.to change(Discipline, :count).by(-1)
    end
  end
end
