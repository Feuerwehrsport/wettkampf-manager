require 'rails_helper'

RSpec.describe FireSportStatistics::PublishingsController, type: :controller, seed: :configured, user: :logged_in do
  let(:discipline) { create(:fire_relay) }

  describe 'GET new' do
    it 'renders form' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'publishes' do
      expect_any_instance_of(FireSportStatistics::API::Post).to receive(:post).with(
        :import_requests, 'import_request[compressed_data]': '--'
      ).and_return({})
      expect_any_instance_of(Exports::FullDump).to receive(:to_export_data).and_return('--')

      post :create
      expect(response).to redirect_to root_path
    end

    context 'when it raises errors' do
      it 'renders form again' do
        expect_any_instance_of(FireSportStatistics::API::Post).to receive(:post).with(
          :import_requests, 'import_request[compressed_data]': '--'
        ).and_raise(Errno::ECONNREFUSED.new('foo'))
        expect_any_instance_of(Exports::FullDump).to receive(:to_export_data).and_return('--')

        post :create
        expect(response).to be_successful
      end
    end
  end
end
