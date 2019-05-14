require 'rails_helper'

RSpec.describe Score::ResultEntrySupport, type: :model do
  let(:result_entry_class) do
    Class.new do
      include Score::ResultEntrySupport
      attr_accessor :time
    end
  end
  let(:result_entry) { result_entry_class.new }

  describe '.second_time' do
    it 'assign edit time' do
      expect(result_entry.edit_second_time).to eq ''

      result_entry.edit_second_time = '12.12'
      expect(result_entry.edit_second_time).to eq '12.12'
      expect(result_entry.time).to eq 1212

      result_entry.edit_second_time = '12.02'
      expect(result_entry.edit_second_time).to eq '12.02'
      expect(result_entry.time).to eq 1202

      result_entry.edit_second_time = '12.20'
      expect(result_entry.edit_second_time).to eq '12.20'
      expect(result_entry.time).to eq 1220

      result_entry.edit_second_time = '9.20'
      expect(result_entry.edit_second_time).to eq '9.20'
      expect(result_entry.time).to eq 920
    end
  end
end
