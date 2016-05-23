require 'rails_helper'

RSpec.describe Imports::Configuration, type: :model do
  
  describe 'import' do
    let(:configuration) { create(:imports_configuration) }

    context "without assessments" do
      it "imports only entities" do
        Rails.application.load_seed
        configuration.update_attributes!(execute: "1")
        expect(configuration.executed_at).to_not be_nil
        expect(Person.count).to be 6
        expect(PersonTag.count).to be 2
        expect(Team.count).to be 2
        expect(TeamTag.count).to be 1
        expect(Assessment.count).to be 0
        expect(Competition.first.attributes).to include(
          "name" => "Deutschland-Cup", 
          "date" => Date.parse("2016-03-09"), 
          "place" => "Rostock"
        )
      end
    end

    context "without assessments" do
      it "imports only entities" do
        Rails.application.load_seed
        CompetitionSeed.find(4).execute # dcup mit allen Disziplinen
        configuration.update_attributes!(execute: "1")
        expect(configuration.executed_at).to_not be_nil
        
        expect(Person.count).to be 6
        expect(PersonTag.count).to be 2
        expect(PersonTag.first.tag_references.count).to be 8
        expect(PersonTag.last.tag_references.count).to be 3
        
        expect(Team.count).to be 2
        expect(TeamTag.count).to be 1
        expect(TeamTag.last.tag_references.count).to be 1

        expect(Assessment.count).to be 11
        expect(AssessmentRequest.count).to be 15
        expect(Competition.first.attributes).to include(
          "name" => "Deutschland-Cup", 
          "date" => Date.parse("2016-03-09"), 
          "place" => "Rostock"
        )

        expect(Team.first.requests.map(&:relay_count)).to match_array [1, 2]
        expect(Team.last.requests.map(&:relay_count)).to match_array [1, 2]
      end
    end
  end
end
