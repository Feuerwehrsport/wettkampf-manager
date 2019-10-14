require 'rails_helper'

RSpec.describe Certificates::ImportsController, type: :controller, seed: :configured, user: :logged_in do
  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    it 'creates template' do
      post :create, params: { certificates_import: { file: fixture_file_upload('certificates_import.json') } }
      expect(response).to redirect_to certificates_template_path(Certificates::Template.last)
      expect(Certificates::Template.last.text_fields.count).to eq 15
      expect(Certificates::Template.last.image).to be_present
      expect(Certificates::Template.last.font).to be_present
      expect(Certificates::Template.last.font2).to be_present
      expect(Certificates::Template.last.name).to eq 'Mannschaft nur Wappen'
    end
  end
end
