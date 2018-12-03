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
end
