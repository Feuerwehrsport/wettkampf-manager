require 'rails_helper'

RSpec.describe Certificates::Import, type: :model do
  describe '#save' do
    context 'when no json data given' do
      let(:import) { described_class.new(file: fixture_file_upload('other.file')) }

      it 'adds error' do
        expect(import.save).to eq false
        expect(import.errors.messages).to eq(file: ['ist nicht gültig'])
      end
    end
    context 'when json data given' do
      let(:import) { described_class.new(file: fixture_file_upload('certificates_import.json')) }

      it 'creates template' do
        expect do
          expect(import.save).to eq true
        end.to change(Certificates::Template, :count).by(1)
      end
    end
  end
end
