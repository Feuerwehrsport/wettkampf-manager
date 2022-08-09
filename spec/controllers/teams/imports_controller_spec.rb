# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Teams::ImportsController, type: :controller, seed: :configured, user: :logged_in do
  let(:team) { create(:team) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates teams per line' do
      lines = [
        team.name,
        " #{team.name}",
        " #{team.name.upcase}",
        " #{team.name.upcase}  ",
        'Berlin',
        'Frankfurt',
        '',
        ' ',
      ]
      expect do
        post :create, params: { teams_import: { gender: team.gender, import_rows: lines.join("\n") } }
        expect(response).to redirect_to teams_path
      end.to change(Team, :count).by(2)
    end
  end
end
