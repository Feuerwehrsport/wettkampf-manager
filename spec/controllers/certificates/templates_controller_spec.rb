require 'rails_helper'

RSpec.describe Certificates::TemplatesController, type: :controller, seed: :configured, user: :logged_in do
  let(:template) { create(:certificates_template, :with_text_fields) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates template' do
      post :create, params: { certificates_template: { name: 'Hindernisbahn' } }
      expect(response).to redirect_to action: :show, id: Certificates::Template.last
    end
  end

  describe 'POST duplicate' do
    it 'duplicate existing template' do
      expect do
        post :duplicate, params: { id: template }
        expect(response).to redirect_to action: :show, id: Certificates::Template.last
      end.to change(Certificates::Template, :count).by(2)
    end
  end

  describe 'GET show' do
    it 'renders show' do
      get :show, params: { id: template }
      expect(response).to be_successful
    end

    context 'when json export' do
      it 'renders show' do
        get :show, params: { id: template, format: :json }
        expect(response).to be_successful
        expect(JSON.parse(response.body, symbolize_names: true).keys).to eq(
          %i[name image image_content_type image_name font font_content_type font_name
             font2 font2_content_type font2_name text_fields],
        )
      end
    end

    context 'when pdf requested' do
      it 'sends pdf' do
        get :show, params: { id: template, format: :pdf }
        expect(response).to be_successful
        expect(response.headers['Content-Type']).to eq Mime[:pdf]
        expect(response.headers['Content-Disposition']).to eq 'inline; filename="urkundenvorlage-hindernisbahn.pdf"'
      end
    end
  end

  describe 'GET index' do
    it 'renders index' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET edit' do
    render_views

    it 'renders form' do
      get :edit, params: { id: template }
      expect(response).to be_successful
      expect(response).to render_template partial: '_form_edit'
    end

    context 'when form type is text_positions' do
      it 'renders text position form' do
        get :edit, params: { id: template, form_type: 'text_positions' }
        expect(response).to be_successful
        expect(response).to render_template partial: '_form_text_fields'
      end
    end
  end

  describe 'PATCH update' do
    it 'updates' do
      patch :update, params: { id: template, certificates_template: { name: 'neu' } }
      expect(response).to redirect_to template
    end
  end

  describe 'DELETE destroy' do
    it 'deletes' do
      delete :destroy, params: { id: template }
      expect(response).to redirect_to action: :index
    end
  end
end
