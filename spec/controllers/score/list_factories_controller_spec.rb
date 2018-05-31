require 'rails_helper'

RSpec.describe Score::ListFactoriesController, type: :controller, seed: :configured, user: :logged_in do
  let(:score_list) { create(:score_list) }

  describe 'GET copy_list' do
    it 'renders form' do
      get :copy_list, list_id: score_list.id
      expect(response).to redirect_to edit_score_list_factories_path

      factory = Score::ListFactory.first
      expect(factory.status).to eq :generator
      expect(factory.track_count).to eq 2
      expect(factory.results).to eq score_list.results
      expect(factory.assessments).to eq score_list.assessments
      expect(factory.session_id).to be_present
      expect(factory.type).to eq 'Score::ListFactories::TrackChange'
    end
  end
end
