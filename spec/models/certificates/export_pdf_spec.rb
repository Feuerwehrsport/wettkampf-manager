require 'rails_helper'

RSpec.describe Certificates::ExportPDF, type: :model do
  let(:template) { create(:certificates_template, :with_text_fields, font: nil) }
  let(:pdf) { Prawn::Document.new }
  let(:short_row) { build(:score_result_row).decorate }
  let(:long_row) { build(:score_result_row).decorate }

  it do
    expect(long_row).to receive(:get).and_return 'a' * 1000
    expect(short_row).to receive(:get).and_return 'b' * 10
    described_class.new(pdf, template, [short_row, long_row], true).render
    expect(pdf.render.size).to be_within(18_790).of(100)
  end
end
