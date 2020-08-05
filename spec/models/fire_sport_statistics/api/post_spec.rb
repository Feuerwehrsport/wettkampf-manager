# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FireSportStatistics::API::Post, type: :model do
  let(:instance) { described_class.new }
  let(:export_hash) do
    {
      name: 'Wettkampf-Name',
      date: Date.current.to_s,
    }
  end
  let(:compressed_data) { Zlib::Deflate.deflate(export_hash.to_json) }

  describe '.post' do
    it 'returns array of open structs', vcr: true do
      instance.post(:import_requests, 'import_request[compressed_data]': compressed_data)
    end
  end
end
