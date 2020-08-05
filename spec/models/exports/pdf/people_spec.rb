# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::PDF::People, type: :model do
  let(:index_pdf) { described_class.perform(Person.all) }
  let!(:female) { create(:person, :female).decorate }
  let!(:male) { create(:person, :male, :with_team).decorate }

  describe 'perform' do
    it 'creates pdf' do
      expect(index_pdf.bytestream).to start_with '%PDF-1.3'
      expect(index_pdf.bytestream).to end_with "%%EOF\n"
      expect(index_pdf.bytestream.size).to be_within(40_308).of(2000)

      expect(index_pdf.filename).to eq 'wettkaempfer.pdf'
    end
  end
end
