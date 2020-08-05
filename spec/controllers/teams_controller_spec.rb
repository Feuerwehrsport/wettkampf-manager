# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamsController, type: :controller, seed: :configured, user: :logged_in do
  let(:team) { create(:team) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET statistic_suggestions' do
    it 'renders form' do
      get :statistic_suggestions, xhr: true, params: { id: team.id }
      expect(response).to be_successful
      expect(response.content_type).to eq 'text/javascript'
    end
  end

  describe 'GET without_statistics_id' do
    before { team }

    render_views

    it 'renders form' do
      get :without_statistics_id
      expect(response).to be_successful
      expect(assigns(:team_suggestions).map(&:team)).to eq [team]
    end
  end

  describe 'GET edit_assessment_requests' do
    it 'renders form' do
      get :edit_assessment_requests, xhr: true, params: { id: team.id }
      expect(response).to be_successful
      expect(response.content_type).to eq 'text/javascript'
    end
  end

  describe 'POST create' do
    it 'creates team' do
      expect do
        post :create, params: { team: { name: 'FF Warin', shortcut: 'Warin', gender: :male, number: 1 } }
        expect(response).to redirect_to teams_path
      end.to change(Team, :count).by(1)
    end

    context 'when single_discipline exists' do
      before { allow(controller).to receive(:single_discipline_exists?).and_return(true) }

      it 'creates team' do
        post :create, params: { team: { name: 'FF Warin', shortcut: 'Warin', gender: :male, number: 1 } }
        expect(response).to redirect_to team_path(Team.last.id)
      end
    end
  end

  describe 'GET show' do
    it 'renders form' do
      get :show, params: { id: team.id }
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
        expect(response.headers['Content-Disposition']).to eq 'inline; filename="mannschaften.pdf"'
      end
    end

    context 'when xlsx requested' do
      it 'sends xlsx' do
        get :index, format: :xlsx
        expect(response).to be_successful
        expect(response.headers['Content-Type']).to eq Mime[:xlsx]
        expect(response.headers['Content-Disposition']).to eq 'attachment; filename="mannschaften.xlsx"'
      end
    end
  end

  describe 'GET edit' do
    it 'renders form' do
      get :edit, params: { id: team.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH update' do
    it 'updates team' do
      patch :update, params: { id: team.id, team: { name: 'foo' } }
      expect(response).to redirect_to action: :show, id: team.id
    end
  end

  describe 'DELETE destroy' do
    before { team }

    it 'destroys team' do
      expect do
        delete :destroy, params: { id: team.id }
        expect(response).to redirect_to action: :index
      end.to change(Team, :count).by(-1)
    end
  end
end
