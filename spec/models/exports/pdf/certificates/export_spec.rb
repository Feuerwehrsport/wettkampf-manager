# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exports::PDF::Certificates::Export, type: :model do
  let(:export_pdf) { described_class.perform(template, 'title', [short_row, long_row], true) }
  let(:template) { create(:certificates_template, :with_text_fields, font: nil) }
  let(:short_row) { build(:score_result_row).decorate }
  let(:long_row) { build(:score_result_row).decorate }

  describe 'perform' do
    it 'creates pdf' do
      expect(long_row).to receive(:get).twice.and_return 'a' * 1000
      expect(short_row).to receive(:get).twice.and_return 'b' * 10

      expect(export_pdf.bytestream).to start_with '%PDF-1.'
      expect(export_pdf.bytestream).to end_with "%%EOF\n"
      expect(export_pdf.bytestream.size).to be_within(40_308).of(2000)
    end
  end
end
