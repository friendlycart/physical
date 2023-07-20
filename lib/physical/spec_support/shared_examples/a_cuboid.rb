# frozen_string_literal: true

RSpec.shared_examples "a cuboid" do
  subject(:cuboid) { described_class.new(**args) }

  it_behaves_like "has property readers"

  let(:args) do
    {
      dimensions: [
        Measured::Length.new(1.1, :cm),
        Measured::Length.new(3.3, :cm),
        Measured::Length.new(2.2, :cm)
      ]
    }
  end

  it { is_expected.to be_a(Physical::Cuboid) }
  it { is_expected.to respond_to(:id) }

  describe "#dimensions" do
    subject(:dimensions) { cuboid.dimensions }

    it "has dimensions as Measured::Length objects with rational values" do
      expect(dimensions).to eq(
        [
          Measured::Length.new(1.1, :cm),
          Measured::Length.new(3.3, :cm),
          Measured::Length.new(2.2, :cm)
        ]
      )
    end

    context "when given a one-element dimensions array" do
      let(:args) do
        {
          dimensions: [Measured::Length(2, :cm)]
        }
      end

      specify "the other dimensions are filled up with default length" do
        expect(dimensions).to eq(
          [
            Measured::Length.new(2, :cm),
            Measured::Length.new(default_length, :cm),
            Measured::Length.new(default_length, :cm)
          ]
        )
      end
    end

    context "when given a two-element dimensions array" do
      let(:args) do
        {
          dimensions: [1, 2].map { |d| Measured::Length(d, :cm) }
        }
      end

      it "the last dimension is filled up with default length" do
        expect(dimensions).to eq(
          [
            Measured::Length.new(1, :cm),
            Measured::Length.new(2, :cm),
            Measured::Length.new(default_length, :cm)
          ]
        )
      end
    end

    context "when given no arguments" do
      let(:args) { {} }

      it "assumes cm as the dimension_unit and the default length as value" do
        expect(dimensions).to eq(
          [
            Measured::Length.new(default_length, :cm),
            Measured::Length.new(default_length, :cm),
            Measured::Length.new(default_length, :cm)
          ]
        )
      end
    end
  end

  describe "dimension methods" do
    it "has getter methods for each dimension as Measured::Length object" do
      expect(cuboid.length).to eq(Measured::Length.new(1.1, :cm))
      expect(cuboid.width).to eq(Measured::Length.new(3.3, :cm))
      expect(cuboid.height).to eq(Measured::Length.new(2.2, :cm))
    end
  end

  describe "#weight" do
    subject(:weight) { cuboid.weight }

    context "with no weight given" do
      let(:args) { {} }
      it { is_expected.to eq(Measured::Weight(0, :g)) }
    end

    context "with a weight" do
      let(:args) { { weight: Measured::Weight(1, :lb) } }
      it { is_expected.to eq(Measured::Weight(453.59237, :g)) }
    end
  end

  describe "#volume" do
    subject(:volume) { cuboid.volume }

    context "if all three dimensions are given" do
      let(:args) do
        {
          dimensions: [1.1, 2.1, 3.2].map { |d| Measured::Length(d, :cm) }
        }
      end

      it { is_expected.to eq(Measured::Volume(7.392, :ml)) }
    end

    context "if a dimension is missing" do
      let(:args) do
        {
          dimensions: [1.1, 2.1].map { |d| Measured::Length(d, :cm) }
        }
      end

      it { is_expected.to eq(Measured::Volume(default_length, :ml)) }
    end
  end

  describe "#density" do
    subject(:density) { cuboid.density.value.to_f }

    let(:args) do
      {
        dimensions: dimensions,
        weight: weight
      }
    end

    context "if volume is larger than 0" do
      let(:dimensions) do
        [1.1, 2.1, 3.2].map { |d| Measured::Length(d, :in) }
      end

      context "if weight is 1" do
        let(:weight) { Measured::Weight(1, :pound) }

        it "returns the density in gramms per cubiq centimeter (ml)" do
          is_expected.to eq(3.7445758536530196)
        end
      end

      context "if weight is 0" do
        let(:weight) { Measured::Weight(0, :pound) }

        it { is_expected.to eq(0.0) }
      end
    end

    context "if volume is 0" do
      let(:dimensions) do
        [1.1, 2.1].map { |d| Measured::Length(d, :in) }
      end

      let(:weight) { Measured::Weight(1, :pound) }
      let(:expected_volume) { default_length.zero? ? BigDecimal::INFINITY : 0 }

      it { is_expected.to eq(expected_volume) }
    end

    context "if volume is infinite" do
      let(:dimensions) do
        [1.1, 2.1].map { |d| Measured::Length(d, :in) }
      end

      let(:weight) { Measured::Weight(1, :pound) }
      let(:expected_volume) { default_length.zero? ? BigDecimal::INFINITY : 0 }

      it { is_expected.to eq(expected_volume) }
    end
  end

  describe "#==" do
    let(:args) { Hash[id: 123] }
    let(:other_cuboid) { described_class.new(**args) }
    let(:non_cuboid) { double(id: 123) }

    it "compares cuboids" do
      aggregate_failures do
        expect(cuboid == other_cuboid).to be(true)
        expect(cuboid == non_cuboid).to be(false)
        expect(cuboid.nil?).to be(false)
      end
    end
  end
end
