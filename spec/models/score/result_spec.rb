require 'rails_helper'

RSpec.describe Score::Result, type: :model do
  let(:result) { create :score_result }
  
  describe '.rows' do
    let(:person1) { create :person, :generated }
    let(:person2) { create :person, :generated }
    let(:person3) { create :person, :generated }
    let(:person4) { create :person, :generated }
    context "entries given" do
      let!(:list1) { create_score_list(result, person1 => 1912, person2 => 2020, person3 => 2040, person4 => nil) }
      let!(:list2) { create_score_list(result, person1 => nil, person2 => 1911, person3 => 1912, person4 => 2040) }


      it "return results in correct order" do
        rows = result.rows
        expect(rows).to have(4).entries

        expect(rows.first.result_entry_from(list1).time).to eq 2020
        expect(rows.first.result_entry_from(list2).time).to eq 1911
        expect(rows.first.best_result_entry.time).to eq 1911

        expect(rows.second.result_entry_from(list1).time).to eq 2040
        expect(rows.second.result_entry_from(list2).time).to eq 1912
        expect(rows.second.best_result_entry.time).to eq 1912

        expect(rows.third.result_entry_from(list1).time).to eq 1912
        expect(rows.third.result_entry_from(list2).time).to be_nil
        expect(rows.third.best_result_entry.time).to eq 1912

        expect(rows.last.result_entry_from(list1).time).to be_nil
        expect(rows.last.result_entry_from(list2).time).to eq 2040
        expect(rows.last.best_result_entry.time).to eq 2040
      end
    end

    context "entries similar" do
      let!(:list1) { create_score_list(result, person1 => 1912, person2 => 1912) }
      let!(:list2) { create_score_list(result, person2 => 1913) }


      it "return results in correct order" do
        rows = result.rows
        expect(rows).to have(2).entries

        expect(rows.first.entity).to eq person2
        expect(rows.first.result_entry_from(list1).time).to eq 1912
        expect(rows.first.result_entry_from(list2).time).to eq 1913

        expect(rows.second.entity).to eq person1
        expect(rows.second.result_entry_from(list1).time).to eq 1912
        expect(rows.second.result_entry_from(list2)).to be_nil
      end
    end
  end
end
