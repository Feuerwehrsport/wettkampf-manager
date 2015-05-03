require 'rails_helper'

RSpec.describe Score::Result, type: :model do
  let(:score_result) { create :score_result }
  
  describe '.rows' do
    context "entries given" do
      let!(:list1) { create :score_list, result: score_result }
      let!(:list_entry11) { create :score_list_entry, :result_valid, :generate_person, list: list1 }
      let!(:electronic_time11) { create :score_electronic_time, list_entry: list_entry11, time: 2100 }
      let!(:list_entry12) { create :score_list_entry, :result_valid, :generate_person, list: list1 }
      let!(:electronic_time12) { create :score_electronic_time, list_entry: list_entry12, time: 2000 }
      let!(:list2) { create :score_list, result: score_result }
      let!(:list_entry21) { create :score_list_entry, :result_valid, list: list2, entity: list_entry11.entity }
      let!(:electronic_time21) { create :score_electronic_time, list_entry: list_entry21, time: 2200 }
      let!(:list_entry22) { create :score_list_entry, :result_valid, list: list2, entity: list_entry12.entity }
      let!(:electronic_time22) { create :score_electronic_time, list_entry: list_entry22, time: 2300 }

      it "return results in correct order" do
        rows = score_result.rows
        expect(rows).to have(2).entries

        expect(rows.first.time_from list1).to eq electronic_time11
        expect(rows.first.time_from list2).to eq electronic_time21
        expect(rows.first.best_stopwatch_time).to eq electronic_time11

        expect(rows.last.time_from list1).to eq electronic_time12
        expect(rows.last.time_from list2).to eq electronic_time22
        expect(rows.last.best_stopwatch_time).to eq electronic_time12
      end
    end
  end
end
