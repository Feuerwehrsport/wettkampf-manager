require 'rails_helper'

RSpec.describe API::TimyReader, type: :model do
  let(:reader) { described_class.new }
  
  describe '.evaluate_output' do
    it 'split lines' do
      reader.evaluate_output("yNNNNxCCCxHH:MM:SS.zhtqxGGRRRR\r")
      reader.evaluate_output(" 0001 c0  15:43:49,8863 00    \r")
      reader.evaluate_output(" 0015 c0M 15:43:55,6200 00    \r")
    end
  end
end
