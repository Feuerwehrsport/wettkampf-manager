# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListPrintGeneratorsController, type: :controller, seed: :configured, user: :logged_in do
  let(:person1) { create(:person, :generated, :with_team) }
  let(:person2) { create(:person, :generated) }
  let(:assessment) { create(:assessment) }
  let(:result) { create(:score_result, assessment: assessment) }
  let(:list) { create_score_list(result, person1 => 2200, person2 => nil) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates result' do
      post :create, params: { score_list_print_generator: {
        print_list: "#{list.id},column,#{list.id},page,#{list.id}",
      } }
      expect(response).to be_successful
      expect(response.body).to start_with '%PDF-1.4'
      expect(response.headers['Content-Type']).to eq Mime[:pdf]
      expect(response.headers['Content-Disposition']).to eq 'inline'
    end
  end
end
