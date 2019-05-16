require 'rails_helper'

RSpec.describe DashboardController, type: :controller, seed: :configured do
  before { allow(Competition.one).to receive(:configured?).and_return(true) }

  describe 'GET show' do
    it 'renders' do
      get :show
      expect(response).to be_success
    end
  end

  describe 'GET flyer' do
    it 'renders' do
      get :flyer
      expect(response).to be_success
      expect(response.headers['Content-Type']).to eq Mime::PDF
      expect(response.headers['Content-Disposition']).to eq 'inline; filename="flyer.pdf"'
    end
  end

  describe 'GET impressum' do
    it 'renders' do
      get :impressum
      expect(response).to be_success
    end
  end
end
