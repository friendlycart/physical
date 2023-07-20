# frozen_string_literal: true

RSpec.describe Physical::Pallet do
  let(:args) { {} }
  subject { described_class.new(**args) }

  it_behaves_like 'a cuboid' do
    let(:default_length) { BigDecimal::INFINITY }
  end

  it { is_expected.to respond_to(:inner_volume) }
  it { is_expected.to respond_to(:inner_dimensions) }
  it { is_expected.to respond_to(:inner_length) }
  it { is_expected.to respond_to(:inner_width) }
  it { is_expected.to respond_to(:inner_height) }

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

  describe "#package_fits?" do
    let(:args) do
      {
        dimensions: [165, 120, 80].map { |d| Measured::Length(d, :cm) },
        max_weight: Measured::Weight(2000, :lbs)
      }
    end

    subject { described_class.new(**args).package_fits?(package) }

    context "with package that fits" do
      let(:package) do
        Physical::Package.new(
          dimensions: [50, 40, 25].map { |d| Measured::Length(d, :cm) },
          weight: Measured::Weight(100, :lbs)
        )
      end
      it { is_expected.to be(true) }
    end

    context "with package that is too big" do
      let(:package) do
        Physical::Package.new(
          dimensions: [200, 150, 120].map { |d| Measured::Length(d, :cm) },
          weight: Measured::Weight(100, :lbs)
        )
      end

      it { is_expected.to be(false) }
    end

    context "with package that is too heavy" do
      let(:package) do
        Physical::Package.new(
          dimensions: [50, 40, 25].map { |d| Measured::Length(d, :cm) },
          weight: Measured::Weight(2500, :lbs)
        )
      end

      it { is_expected.to be(false) }
    end
  end
end
