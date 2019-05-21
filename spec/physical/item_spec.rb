# frozen_string_literal: true

RSpec.describe Physical::Item do
  subject(:item) { described_class.new(args) }

  it_behaves_like 'a cuboid'

  context "when given a one-element dimensions array" do
    let(:args) { {dimensions: [Measured::Length(2, :cm)]} }

    specify "the other dimensions are filled up with 0" do
      expect(subject.dimensions).to eq(
        [
          Measured::Length.new(0, :cm),
          Measured::Length.new(0, :cm),
          Measured::Length.new(2, :cm)
        ]
      )
    end
  end

  context "when given a two-element dimensions array" do
    let(:args) { {dimensions: [1, 2].map { |d| Measured::Length(d, :cm) }} }

    it "the last dimension is filled up with 0" do
      expect(subject.dimensions).to eq(
        [
          Measured::Length.new(0, :cm),
          Measured::Length.new(1, :cm),
          Measured::Length.new(2, :cm)
        ]
      )
    end
  end

  context "when given no arguments" do
    let(:args) { {} }

    it "assumes cm as the dimension_unit and 0 as value" do
      expect(subject.dimensions).to eq(
        [
          Measured::Length.new(0, :cm),
          Measured::Length.new(0, :cm),
          Measured::Length.new(0, :cm)
        ]
      )
    end
  end

  describe "#volume" do
    subject { described_class.new(args).volume }

    context "if all three dimensions are given" do
      let(:args) { {dimensions: [1.1, 2.1, 3.2].map { |d| Measured::Length(d, :cm) }} }

      it "returns the correct volume" do
        expect(subject).to eq(Measured::Volume(7.392, :ml))
      end
    end

    context "if a dimension is missing" do
      let(:args) { {dimensions: [1.1, 2.1].map { |d| Measured::Length(d, :cm) }} }

      it "returns the correct volume" do
        expect(subject).to eq(Measured::Volume(0, :ml))
      end
    end
  end

  describe "#weight" do
    subject { described_class.new(args).weight }

    context "with no weight given" do
      let(:args) { {} }
      it { is_expected.to eq(Measured::Weight(0, :g)) }
    end

    context "with a weight" do
      let(:args) { {weight: Measured::Weight(1, :lb)} }
      it { is_expected.to eq(Measured::Weight(453.59237, :g)) }
    end
  end

  describe '#properties' do
    let(:args) { {properties: {flammable: true}} }

    subject { item.properties }

    it { is_expected.to eq(flammable: true) }
  end

  describe 'factory' do
    subject { FactoryBot.build(:physical_item) }

    it 'has coherent attributes' do
      expect(subject.dimensions.map(&:value)).to eq([1, 2, 3])
      expect(subject.weight.value).to eq(50)
    end
  end
end
