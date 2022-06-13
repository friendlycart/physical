# frozen_string_literal: true

RSpec.describe Physical::Pallet do
  subject { described_class.new(**args) }

  it_behaves_like 'a cuboid'

  context "when given a one-element dimensions array" do
    let(:args) { { dimensions: [Measured::Length(2, :cm)] } }

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
    let(:args) { { dimensions: [1, 2].map { |d| Measured::Length(d, :cm) } } }

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
    subject { described_class.new(**args).volume }

    context "if all three dimensions are given" do
      let(:args) { { dimensions: [1.1, 2.1, 3.2].map { |d| Measured::Length(d, :cm) } } }

      it "returns the correct volume" do
        expect(subject).to eq(Measured::Volume(7.392, :ml))
      end
    end

    context "if a dimension is missing" do
      let(:args) { { dimensions: [1.1, 2.1].map { |d| Measured::Length(d, :cm) } } }

      it "is infinitely large" do
        expect(subject).to eq(Measured::Volume(BigDecimal::INFINITY, :ml))
      end
    end
  end

  describe '#density' do
    subject { described_class.new(**args).density.value.to_f }

    let(:args) do
      {
        dimensions: dimensions,
        weight: weight
      }
    end

    context "if volume is infinite" do
      let(:dimensions) do
        [1.1, 2.1].map { |d| Measured::Length(d, :in) }
      end

      let(:weight) { Measured::Weight(1, :pound) }

      it { is_expected.to eq(0.0) }
    end
  end

  describe "#weight" do
    subject { described_class.new(**args).weight }

    context "with no weight given" do
      let(:args) { {} }
      it { is_expected.to eq(Measured::Weight(0, :g)) }
    end

    context "with a weight unit given" do
      let(:args) { { weight: Measured::Weight(1, :lbs) } }
      it { is_expected.to eq(Measured::Weight(453.59237, :g)) }
    end
  end

  describe "#max_weight" do
    subject { described_class.new(**args).max_weight }

    context "with no max_weight given" do
      let(:args) { {} }
      it { is_expected.to eq(Measured::Weight(BigDecimal::INFINITY, :g)) }
    end

    context "with a max_weight unit given" do
      let(:args) { { max_weight: Measured::Weight(1, :lbs) } }
      it { is_expected.to eq(Measured::Weight(453.59237, :g)) }
    end
  end

  describe 'factory' do
    subject { FactoryBot.build(:physical_pallet) }

    it 'has coherent attributes' do
      expect(subject.dimensions.map { |d| d.convert_to(:cm).value }).to eq([80, 120, 165])
      expect(subject.weight.convert_to(:kg).value).to eq(22)
    end
  end
end
