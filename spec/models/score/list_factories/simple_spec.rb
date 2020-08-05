# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListFactories::Simple, type: :model do
  let(:factory) { create :score_list_factory_simple }

  before do
    create_list(:person, 5, :with_team).each { |person| person.requests.create!(assessment: factory.assessments.first) }
    factory.reload
  end

  describe 'perform' do
    it 'create list entries' do
      factory.list
      expect { factory.perform }.to change(Score::ListEntry, :count).by(5)
    end
  end
end
