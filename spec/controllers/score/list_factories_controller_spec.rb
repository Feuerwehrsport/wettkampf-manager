# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListFactoriesController, type: :controller, seed: :configured, user: :logged_in do
  let(:discipline) { create(:climbing_hook_ladder) }
  let(:score_list) { create(:score_list) }

  describe 'GET copy_list' do
    it 'renders form' do
      get :copy_list, params: { list_id: score_list.id }
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

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates list_factory' do
      expect do
        post :create, params: { score_list_factory: { discipline_id: discipline.id, next_step: 'assessments' } }
        expect(response).to redirect_to action: :edit
      end.to change(Score::ListFactory, :count).by(1)
    end
  end

  context 'when factory exists' do
    let(:list_factory) { create(:score_list_factory_simple, next_step: 'assessments') }

    before { allow(controller).to receive(:find_resource).and_return(list_factory) }

    describe 'GET edit' do
      it 'renders form' do
        get :edit
        expect(response).to be_successful
      end
    end

    describe 'PATCH update' do
      it 'updates list_factory' do
        patch :update, params: { score_list_factory: { name: 'foo' } }
        expect(response).to redirect_to action: :edit
      end

      context 'when last action' do
        it 'destroys list_factory' do
          expect do
            expect do
              patch :update, params: { score_list_factory: { next_step: 'create' } }
              expect(response).to redirect_to score_list_path(Score::List.last.id)
            end.to change(Score::ListFactory, :count).by(-1)
          end.to change(Score::List, :count).by(1)
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys list_factory' do
        expect do
          delete :destroy
          expect(response).to redirect_to score_lists_path
        end.to change(Score::ListFactory, :count).by(-1)
      end
    end
  end
end
