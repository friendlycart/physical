# frozen_string_literal: true

RSpec.describe Physical::Box do
  subject { described_class.new(args) }
  let(:args) { {dimensions: [1, 2, 3], dimension_unit: :cm} }

  it "has dimensions as Measured::Length objects" do
    expect(subject.dimensions).to eq(
      [
        Measured::Length.new(1, :cm),
        Measured::Length.new(2, :cm),
        Measured::Length.new(3, :cm)
      ]
    )
  end

  context "when given a one-element dimensions array" do
    let(:args) { {dimensions: [2], dimension_unit: :cm} }

    specify "the other dimensions are filled up with BigDecimal::INFINITY" do
      expect(subject.dimensions).to eq(
        [
          Measured::Length.new(2, :cm),
          Measured::Length.new(BigDecimal::INFINITY, :cm),
          Measured::Length.new(BigDecimal::INFINITY, :cm)
        ]
      )
    end
  end

  context "when given a two-element dimensions array" do
    let(:args) { {dimensions: [1, 2], dimension_unit: :cm} }

    it "the last dimension is filled up with BigDecimal::INFINITY" do
      expect(subject.dimensions).to eq(
        [
          Measured::Length.new(1, :cm),
          Measured::Length.new(2, :cm),
          Measured::Length.new(BigDecimal::INFINITY, :cm)
        ]
      )
    end
  end

  context "when given no arguments" do
    let(:args) { {} }

    it "assumes cm as the unit and infinity as value" do
      expect(subject.dimensions).to eq(
        [
          Measured::Length.new(BigDecimal::INFINITY, :cm),
          Measured::Length.new(BigDecimal::INFINITY, :cm),
          Measured::Length.new(BigDecimal::INFINITY, :cm)
        ]
      )
    end
  end

  describe "#volume" do
    subject { described_class.new(args).volume }

    context "if all three dimensions are given" do
      let(:args) { {dimensions: [1.1, 2.1, 3.2], dimension_unit: :cm} }

      it "returns the correct volume" do
        expect(subject).to eq(Measured::Volume(7.392, :ml))
      end
    end

    context "if a dimension is missing" do
      let(:args) { {dimensions: [1.1, 2.1], dimension_unit: :cm} }

      it "is infinitely large" do
        expect(subject).to eq(Measured::Volume(BigDecimal::INFINITY, :ml))
      end
    end
  end

  describe "#weight" do
    subject { described_class.new(args).weight }

    context "with no weight given" do
      let(:args) { {} }
      it { is_expected.to eq(Measured::Weight(0, :g)) }
    end

    context "with a weight unit given" do
      let(:args) { {weight: 1, weight_unit: :lb} }
      it { is_expected.to eq(Measured::Weight(453.59237, :g)) }
    end

    context "with a weight given" do
      let(:args) { {weight: 200} }
      it { is_expected.to eq(Measured::Weight(200, :g)) }
    end
  end

  describe 'factory' do
    subject { FactoryBot.build(:physical_box) }

    it 'has coherent attributes' do
      expect(subject.dimensions.map(&:value)).to eq([40, 50, 60])
      expect(subject.weight.value).to eq(100)
    end
  end
end
