require 'rails_helper'

RSpec.describe Certificates::ListsController, type: :controller, seed: :configured, user: :logged_in do
  let(:template) { create(:certificates_template, :with_text_fields) }
  let(:result) { create(:score_result) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates list' do
      post :create, params: { certificates_list: { template_id: template.id, image: true, score_result_id: result.id } }
      expect(response).to be_successful
    end
  end

  describe 'POST export' do
    render_views
    it 'creates pdf' do
      post :export, params: { certificates_list:
        { template_id: template.id, image: true, score_result_id: result.id }, format: :pdf }
      expect(response).to be_successful
      expect(response.headers['Content-Type']).to eq 'application/pdf'
      expect(response.headers['Content-Disposition']).to eq 'inline; filename="urkunden-hakenleitersteigen-manner.pdf"'
    end

    context 'when params are not correct' do
      it 'redirects to new' do
        post :export, params: { certificates_list: { score_result_id: result.id }, format: :pdf }
        expect(response).to redirect_to(action: :new)
      end
    end

    context 'when format missing' do
      it 'redirects to new' do
        post :export, params: { certificates_list:
          { template_id: template.id, image: true, score_result_id: result.id } }
        expect(response).to redirect_to(action: :new)
      end
    end
  end
end
