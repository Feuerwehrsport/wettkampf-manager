# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorsController, type: :controller, seed: :configured do
  render_views
  describe 'GET not_found' do
    it 'renders form' do
      get :not_found
      expect(response).to be_successful
      File.write(Rails.root.join('public/404.html'), response.body)
    end
  end

  describe 'GET internal_server_error' do
    it 'renders form' do
      get :internal_server_error
      expect(response).to be_successful
      File.write(Rails.root.join('public/500.html'), response.body)
    end
  end

  describe 'GET unprocessable_entity' do
    it 'renders form' do
      get :unprocessable_entity
      expect(response).to be_successful
      File.write(Rails.root.join('public/422.html'), response.body)
    end
  end
end
