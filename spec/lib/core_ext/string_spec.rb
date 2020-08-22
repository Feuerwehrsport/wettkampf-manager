# frozen_string_literal: true

require 'rails_helper'

RSpec.describe String, type: :lib do
  describe 'truncate_bytes' do
    it 'truncates on bytes count' do
      expect('a234567890'.truncate_bytes(10)).to eq 'a234567890'
      expect('a234567890a'.truncate_bytes(10)).to eq 'a234567...'
      expect('ä234567890'.truncate_bytes(10)).to eq 'ä23456...'
      expect('äö34567890'.truncate_bytes(10)).to eq 'äö345...'
    end
  end
end
