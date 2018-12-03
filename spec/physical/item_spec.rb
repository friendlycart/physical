# frozen_string_literal: true

RSpec.describe Physical::Item do
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

    specify "the other dimensions are filled up with 0" do
      expect(subject.dimensions).to eq(
        [
          Measured::Length.new(2, :cm),
          Measured::Length.new(0, :cm),
          Measured::Length.new(0, :cm)
        ]
      )
    end
  end

  context "when given a two-element dimensions array" do
    let(:args) { {dimensions: [1, 2], dimension_unit: :cm} }

    it "the last dimension is filled up with 0" do
      expect(subject.dimensions).to eq(
        [
          Measured::Length.new(1, :cm),
          Measured::Length.new(2, :cm),
          Measured::Length.new(0, :cm)
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
      let(:args) { {dimensions: [1.1, 2.1, 3.2], dimension_unit: :cm} }

      it "returns the correct volume" do
        expect(subject).to eq(Measured::Volume(7.392, :ml))
      end
    end

    context "if a dimension is missing" do
      let(:args) { {dimensions: [1.1, 2.1], dimension_unit: :cm} }

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

    context "with a weight unit given" do
      let(:args) { {weight: 1, weight_unit: :lb} }
      it { is_expected.to eq(Measured::Weight(453.59237, :g)) }
    end

    context "with a weight given" do
      let(:args) { {weight: 200} }
      it { is_expected.to eq(Measured::Weight(200, :g)) }
    end
  end
end
