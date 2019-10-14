require 'rails_helper'

RSpec.describe DashboardController, type: :controller, seed: :configured do
  before { allow(Competition.one).to receive(:configured?).and_return(true) }

  describe 'GET show' do
    it 'renders' do
      get :show
      expect(response).to be_successful
    end
  end

  describe 'GET flyer' do
    it 'renders' do
      get :flyer
      expect(response).to be_successful
      expect(response.headers['Content-Type']).to eq Mime[:pdf]
      expect(response.headers['Content-Disposition']).to eq 'inline; filename="flyer.pdf"'
    end
  end

  describe 'GET impressum' do
    it 'renders' do
      get :impressum
      expect(response).to be_successful
    end
  end

  describe 'GET create_backup', user: :logged_in do
    it 'creates backup' do
      expect_any_instance_of(Exports::FullDump).to receive(:to_path).and_return(nil)

      get :create_backup
      expect(response).to redirect_to root_path
      expect(flash[:success]).to starting_with 'Backup wurde unter dem Pfad'
    end
  end
end
