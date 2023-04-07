# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleController, type: :controller, seed: :configured, user: :logged_in do
  let(:team) { create(:team, band: male_band) }
  let(:person) { create(:person, band: male_band) }
  let(:male_band) { create(:band) }

  describe 'GET new' do
    it 'renders form' do
      get :new, params: { band_id: male_band.id }
      expect(response).to be_successful
    end
  end

  describe 'GET statistic_suggestions' do
    it 'renders form' do
      get :statistic_suggestions, xhr: true, params: { id: person.id }
      expect(response).to be_successful
      expect(response.content_type).to eq 'text/javascript'
    end
  end

  describe 'GET without_statistics_id' do
    before { person }

    render_views

    it 'renders form' do
      get :without_statistics_id
      expect(response).to be_successful
      expect(assigns(:person_suggestions).map(&:person)).to eq [person]
    end
  end

  describe 'GET edit_assessment_requests' do
    it 'renders form' do
      get :edit_assessment_requests, xhr: true, params: { id: person.id }
      expect(response).to be_successful
      expect(response.content_type).to eq 'text/javascript'
    end
  end

  describe 'POST create' do
    it 'creates person' do
      expect do
        post :create, params: { format: :js, band_id: male_band.id, person:
          { first_name: 'Alfred', last_name: 'Meier', team_id: team.id } }
        expect(response).to be_successful
        expect(response.content_type).to eq 'text/javascript'
      end.to change(Person, :count).by(1)
    end
  end

  describe 'GET show' do
    it 'renders form' do
      get :show, params: { id: person }
      expect(response).to be_successful
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
        expect(response.headers['Content-Disposition']).to eq 'inline; filename="wettkaempfer.pdf"'
      end
    end

    context 'when xlsx requested' do
      it 'sends xlsx' do
        get :index, format: :xlsx
        expect(response).to be_successful
        expect(response.headers['Content-Type']).to eq Mime[:xlsx]
        expect(response.headers['Content-Disposition']).to eq 'attachment; filename="wettkaempfer.xlsx"'
      end
    end
  end

  describe 'GET edit' do
    it 'renders form' do
      get :edit, params: { id: person.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH update' do
    it 'updates person' do
      patch :update, params: { id: person.id, person: { name: 'foo' } }
      expect(response).to redirect_to action: :show, id: person.id
    end
  end

  describe 'DELETE destroy' do
    before { person }

    it 'destroys person' do
      expect do
        delete :destroy, params: { id: person.id }
        expect(response).to redirect_to action: :index
      end.to change(Person, :count).by(-1)
    end
  end
end
