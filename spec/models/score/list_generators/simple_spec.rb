require 'rails_helper'

RSpec.describe Score::ListGenerators::Simple, type: :model do
  let(:score_list) { create :score_list }
  subject { Score::ListGenerators::Simple.new(list: score_list) }

  before do 
    create_list(:person, 5, :with_team).each { |person| person.requests.create!(assessment: score_list.assessments.first) }
    score_list.reload
  end
  
  describe 'perform' do
    it "create list entries" do
      expect { subject.perform }.to change(Score::ListEntry, :count).by(5)
    end
  end
end
