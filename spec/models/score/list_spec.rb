require 'rails_helper'

RSpec.describe Score::List, type: :model do
  let(:score_list) { build_stubbed :score_list }
  
  describe 'validation' do
    context "result_time_type" do
      it "validates" do
        score_list.result_time_type = nil
        expect(score_list).to be_valid
        score_list.result_time_type = ""
        expect(score_list).to be_valid
        score_list.result_time_type = :electronic
        expect(score_list).to_not be_valid
        expect(score_list).to receive(:electronic_time_all_available?).and_return(true)
        expect(score_list).to be_valid
      end
    end
  end

  describe ".available_time_types" do
    let(:list_entry) { create :score_list_entry, :result_valid, list: score_list }
    let(:electronic_time) { create :score_electronic_time, list_entry: list_entry }
    let(:handheld_time) { create :score_handheld_time, list_entry: list_entry }
    let(:list_entry2) { create :score_list_entry, :result_valid, list: score_list }
    let(:handheld_time2) { create :score_handheld_time, list_entry: list_entry2 }
    it "" do
      expect(score_list.available_time_types).to eq []
      electronic_time
      expect(score_list.available_time_types).to eq [:electronic]
      handheld_time
      expect(score_list.available_time_types).to eq [:electronic, :handheld_average]
      handheld_time2
      expect(score_list.available_time_types).to eq [:handheld_average, :calculated]
    end
  end
end
