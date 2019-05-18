require 'rails_helper'

RSpec.describe Exports::PDF::Teams, type: :model do
  let(:index_pdf) { described_class.perform([team]) }
  let(:team) { create(:team).decorate }

  describe 'perform' do
    it 'creates pdf' do
      expect(index_pdf.bytestream).to start_with '%PDF-1.3'
      expect(index_pdf.bytestream).to end_with "%%EOF\n"
      expect(index_pdf.bytestream.size).to be_within(38_727).of(2000)

      expect(index_pdf.filename).to eq 'mannschaften.pdf'
    end
  end
end
