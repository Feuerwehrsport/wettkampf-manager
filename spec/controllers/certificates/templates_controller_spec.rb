require 'rails_helper'

RSpec.describe Certificates::TemplatesController, type: :controller, seed: :configured, user: :logged_in do
  let(:template) { create(:certificates_template) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    it 'creates template' do
      post :create, certificates_template: { name: 'Hindernisbahn' }
      expect(response).to redirect_to action: :show, id: Certificates::Template.last
    end
  end

  describe 'POST duplicate' do
    it 'duplicate existing template' do
      post :duplicate, id: template
      expect(response).to redirect_to action: :show, id: Certificates::Template.last
    end
  end

  describe 'GET show' do
    it 'renders show' do
      get :show, id: template
      expect(response).to be_success
    end
  end

  describe 'GET index' do
    it 'renders index' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET edit' do
    render_views

    it 'renders form' do
      get :edit, id: template
      expect(response).to be_success
      expect(response).to render_template partial: '_form_edit'
    end

    context 'when form type is text_positions' do
      it 'renders text position form' do
        get :edit, id: template, form_type: 'text_positions'
        expect(response).to be_success
        expect(response).to render_template partial: '_form_text_fields'
      end
    end
  end

  describe 'PATCH update' do
    it 'updates' do
      patch :update, id: template, certificates_template: { name: 'neu' }
      expect(response).to redirect_to template
    end
  end

  describe 'DELETE destroy' do
    it 'deletes' do
      delete :destroy, id: template
      expect(response).to redirect_to action: :index
    end
  end
end
