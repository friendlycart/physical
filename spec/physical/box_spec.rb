# frozen_string_literal: true

RSpec.describe Physical::Box do
  subject { described_class.new(**args) }

  it_behaves_like 'a cuboid' do
    let(:default_length) { BigDecimal::INFINITY }
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
    subject { FactoryBot.build(:physical_box) }

    it 'has coherent attributes' do
      expect(subject.dimensions.map { |d| d.convert_to(:cm).value }).to eq([20, 15, 30])
      expect(subject.weight.convert_to(:g).value).to eq(100)
    end
  end

  describe '#inner_dimensions' do
    subject { described_class.new(**args).inner_dimensions }

    context 'if all values are given' do
      let(:args) do
        {
          dimensions: [1.1, 2.1, 3.2].map { |d| Measured::Length(d, :cm) },
          inner_dimensions: [3, 1, 2].map { |d| Measured::Length(d, :cm) }
        }
      end

      it do
        is_expected.to eq([
                            Measured::Length.new(3, :cm),
                            Measured::Length.new(1, :cm),
                            Measured::Length.new(2, :cm)
                          ])
      end
    end

    context 'if a value is missing but outer dimensions are given' do
      let(:args) do
        {
          dimensions: [1.1, 2.1, 3.2].map { |d| Measured::Length(d, :cm) },
          inner_dimensions: [2, 1].map { |d| Measured::Length(d, :cm) }
        }
      end

      it 'fills up with the outer dimensions' do
        is_expected.to eq([
                            Measured::Length.new(2, :cm),
                            Measured::Length.new(1, :cm),
                            Measured::Length.new(3.2, :cm)
                          ])
      end
    end
  end

  describe 'inner length, width, height, volume' do
    subject { described_class.new(**args) }

    let(:args) do
      {
        dimensions: [1.1, 2.1, 3.2].map { |d| Measured::Length(d, :cm) },
        inner_dimensions: [2, 1, 3].map { |d| Measured::Length(d, :cm) }
      }
    end

    it 'does the correct calculations' do
      aggregate_failures do
        expect(subject.inner_length).to eq(Measured::Length(2, :cm))
        expect(subject.inner_width).to eq(Measured::Length(1, :cm))
        expect(subject.inner_height).to eq(Measured::Length(3, :cm))
        expect(subject.inner_volume).to eq(Measured::Volume(6, :ml))
      end
    end
  end

  describe "#item_fits?" do
    let(:args) do
      {
        dimensions: [15, 10, 5].map { |d| Measured::Length(d, :cm) },
        max_weight: Measured::Weight(5, :g)
      }
    end

    subject { described_class.new(**args).item_fits?(item) }

    context "with item that fits" do
      let(:item) do
        Physical::Item.new(
          dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) },
          weight: Measured::Weight(3, :g)
        )
      end
      it { is_expected.to be(true) }
    end

    context "with item that is too big" do
      let(:item) do
        Physical::Item.new(
          dimensions: [20, 15, 10].map { |d| Measured::Length(d, :cm) },
          weight: Measured::Weight(3, :g)
        )
      end

      it { is_expected.to be(false) }
    end

    context "with item that is too heavy" do
      let(:item) do
        Physical::Item.new(
          dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) },
          weight: Measured::Weight(10, :g)
        )
      end

      it { is_expected.to be(false) }
    end
  end
end
