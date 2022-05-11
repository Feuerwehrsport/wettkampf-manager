# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::TimeEntriesController, type: :controller, seed: :configured do
  let(:entry) { create(:api_time_entry) }

  describe 'POST create' do
    context 'when password doesnt match' do
      it 'creates time entries per API' do
        post :create, params: { api_time_entry: { time: '1122', hint: 'hint', password: 'bad', sender: 'sender' } }
        expect(response).to be_successful
        expect(response.body).to eq '{"success":false,"error":{"password":["ist nicht gültig"]}}'
      end
    end

    context 'when password match' do
      it 'creates time entries per API' do
        post :create, params: { api_time_entry: { time: '1122', hint: 'hint', password: 'API', sender: 'sender' } }
        expect(response).to be_successful
        expect(response.body).to eq '{"success":true}'
      end
    end
  end

  describe 'GET index', user: :logged_in do
    it 'renders index' do
      get :index
      expect(response).to be_successful

      expect(assigns(:waiting_time_entries)).to eq([])
      expect(assigns(:closed_time_entries)).to eq([])
      expect(assigns(:lists)).to eq([])
    end
  end

  describe 'PATCH ignore_all', user: :logged_in do
    it 'sets used_at for all waiting entries' do
      entry
      patch :ignore_all
      expect(response).to redirect_to(action: :index)

      expect(API::TimeEntry.waiting).to eq []
    end
  end

  describe 'GET show', user: :logged_in do
    it 'renders show' do
      get :show, params: { id: entry.id }
      expect(response).to be_successful

      expect(assigns(:lists)).to eq([])
    end
  end
end
