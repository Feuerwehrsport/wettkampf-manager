require 'rails_helper'

RSpec.describe Score::ListFactories::Simple, type: :model do
  subject { create :score_list_factory_simple }

  before do
    create_list(:person, 5, :with_team).each { |person| person.requests.create!(assessment: subject.assessments.first) }
    subject.reload
  end
  
  describe 'perform' do
    it "create list entries" do
      expect { subject.perform }.to change(Score::ListEntry, :count).by(5)
    end
  end
end
