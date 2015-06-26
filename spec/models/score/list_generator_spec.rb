require 'rails_helper'

RSpec.describe Score::ListGenerator, type: :model do
  describe ".configuration" do
    it "describes subclasses" do
      expect(described_class.configuration).to have(6).items
      described_class.configuration.each do |key, value|
        expect(key).to be_a(String)
        expect(value).to be_a(Score::ListGenerator::Configuration)
        value.generator_attributes.each do |method|
          expect(described_class.instance_methods).to include(method)
        end
      end
    end
  end

  describe "#for_run_and_track_for" do
    let(:list) { build_stubbed(:score_list, track_count: 2) }
    let(:generator) { described_class.new(list: list) }
    let(:rows) { [1, 2, 3, 4, 5] }

    it "calls create_list_entry for each run and track" do
      expect(generator).to receive(:create_list_entry).with(1, 1, 1)
      expect(generator).to receive(:create_list_entry).with(2, 1, 2)
      expect(generator).to receive(:create_list_entry).with(3, 2, 1)
      expect(generator).to receive(:create_list_entry).with(4, 2, 2)
      expect(generator).to receive(:create_list_entry).with(5, 3, 1)
      generator.send(:for_run_and_track_for, rows)
    end
  end
end
