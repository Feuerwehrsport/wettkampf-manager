require 'rails_helper'

RSpec.describe Imports::ConfigurationsController, type: :controller, seed: :configured, user: :logged_in do
  let(:configuration) { create(:imports_configuration) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end

    context 'when configuration exists' do
      before { configuration }

      it 'redirects' do
        get :new
        expect(response).to redirect_to action: :show, id: configuration
      end
    end
  end

  describe 'POST create' do
    it 'creates configuration' do
      post :create, params: { imports_configuration: { file: fixture_file_upload('import.wettkampf_manager_import') } }
      expect(response).to redirect_to action: :edit, id: Imports::Configuration.last.id
    end

    context 'when configuration exists' do
      before { configuration }

      it 'redirects' do
        post :create, params: { imports_configuration: { file: fixture_file_upload('import.wettkampf_manager_import') } }
        expect(response).to redirect_to action: :show, id: configuration
      end
    end
  end

  describe 'GET show' do
    it 'renders show' do
      get :show, params: { id: configuration }
      expect(response).to be_successful
    end

    context 'when configuration was imported' do
      before { configuration.update(executed_at: Time.current) }

      it 'redirects' do
        get :show, params: { id: configuration }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET index' do
    it 'renders index' do
      get :index
      expect(response).to redirect_to(action: :new)
    end
  end

  describe 'GET edit' do
    it 'renders form' do
      get :edit, params: { id: configuration }
      expect(response).to be_successful
    end

    context 'when configuration was imported' do
      before { configuration.update(executed_at: Time.current) }

      it 'redirects' do
        get :edit, params: { id: configuration }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH update' do
    it 'updates' do
      patch :update, params: { id: configuration, imports_configuration: { name: 'neu' } }
      expect(response).to redirect_to configuration
    end

    context 'when configuration was imported' do
      before { configuration.update(executed_at: Time.current) }

      it 'redirects' do
        patch :update, params: { id: configuration, imports_configuration: { name: 'neu' } }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE destroy' do
    it 'deletes' do
      delete :destroy, params: { id: configuration }
      expect(response).to redirect_to action: :index
    end

    context 'when configuration was imported' do
      before { configuration.update(executed_at: Time.current) }

      it 'redirects' do
        delete :destroy, params: { id: configuration }
        expect(response).to redirect_to root_path
      end
    end
  end
end
