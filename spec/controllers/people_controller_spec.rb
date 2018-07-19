require 'rails_helper'

RSpec.describe PeopleController, type: :controller, seed: :configured, user: :logged_in do
  let(:team) { create(:team) }
  let(:person) { create(:person) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'GET without_statistics_id' do
    before { person }
    it 'renders form' do
      get :without_statistics_id
      expect(response).to be_success
      expect(assigns(:person_suggestions).map(&:person)).to eq [person]
    end
  end

  describe 'GET edit_assessment_requests' do
    it 'renders form' do
      xhr :get, :edit_assessment_requests, id: person.id
      expect(response).to be_success
      expect(response.content_type).to eq 'text/javascript'
    end
  end

  describe 'POST create' do
    it 'creates person' do
      expect do
        post :create, format: :js, person: { first_name: 'Alfred', last_name: 'Meier', gender: :male, team_id: team.id }
        expect(response).to be_success
        expect(response.content_type).to eq 'text/javascript'
      end.to change(Person, :count).by(1)
    end
  end

  describe 'GET show' do
    it 'renders form' do
      get :show, id: person
      expect(response).to be_success
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
      get :edit, id: person.id
      expect(response).to be_success
    end
  end

  describe 'PATCH update' do
    it 'updates person' do
      patch :update, id: person.id, person: { name: 'foo' }
      expect(response).to redirect_to action: :show, id: person.id
    end
  end

  describe 'DELETE destroy' do
    before { person }
    it 'destroys person' do
      expect do
        delete :destroy, id: person.id
        expect(response).to redirect_to action: :index
      end.to change(Person, :count).by(-1)
    end
  end
end
