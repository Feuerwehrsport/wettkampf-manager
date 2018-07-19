require 'rails_helper'

RSpec.describe Imports::Configuration, type: :model do
  describe 'import' do
    let(:configuration) { create(:imports_configuration) }

    context 'without assessments' do
      it 'imports only entities' do
        Rails.application.load_seed
        configuration.update!(execute: '1')
        expect(configuration.executed_at).not_to be_nil
        expect(Person.count).to be 4
        expect(PersonTag.count).to be 2
        expect(Team.count).to be 3
        expect(TeamTag.count).to be 1
        expect(Assessment.count).to be 0
        expect(Competition.first.attributes).to include(
          'name' => 'Deutschland-Cup',
          'date' => Date.parse('2016-03-09'),
          'place' => 'Rostock',
        )
      end
    end

    context 'with assessments' do
      it 'imports entities and assessment requests' do
        Rails.application.load_seed
        Preset.find(3).save # D-Cup mit allen Disziplinen
        configuration.update!(execute: '1')
        expect(configuration.executed_at).not_to be_nil

        expect(Person.count).to be 4
        expect(PersonTag.count).to be 2
        expect(PersonTag.first.tag_references.count).to be 7
        expect(PersonTag.last.tag_references.count).to be 1

        expect(Team.count).to be 3
        expect(TeamTag.count).to be 1
        expect(TeamTag.last.tag_references.count).to be 1

        expect(Assessment.count).to be 11
        expect(AssessmentRequest.count).to be 12
        expect(Competition.first.attributes).to include(
          'name' => 'Deutschland-Cup',
          'date' => Date.parse('2016-03-09'),
          'place' => 'Rostock',
        )

        expect(Team.first.requests.map(&:relay_count)).to match_array []
        expect(Team.second.requests.map(&:relay_count)).to match_array [1]
        expect(Team.last.requests.map(&:relay_count)).to match_array [1, 2]
      end
    end
  end
end
