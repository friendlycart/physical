# frozen_string_literal: true

RSpec.describe Physical::Item do
  subject(:item) { described_class.new(**args) }

  it_behaves_like 'a cuboid'

  context "when given a one-element dimensions array" do
    let(:args) { { dimensions: [Measured::Length(2, :cm)] } }

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
    let(:args) { { dimensions: [1, 2].map { |d| Measured::Length(d, :cm) } } }

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

  describe "#cost" do
    let(:args) { {} }

    subject { described_class.new(**args).cost }

    it { is_expected.to be nil }

    context 'if cost is given' do
      let(:args) { { cost: Money.new(12_345, 'USD') } }

      it { is_expected.to eq(Money.new(12_345, 'USD')) }
    end
  end

  describe "#sku" do
    let(:args) { {} }

    subject { described_class.new(**args).sku }

    it { is_expected.to be nil }

    context 'if sku is given' do
      let(:args) { { sku: 'my_sku' } }

      it { is_expected.to eq('my_sku') }
    end
  end

  describe "#description" do
    let(:args) { {} }

    subject { described_class.new(**args).description }

    it { is_expected.to be nil }

    context 'if description is given' do
      let(:args) { { description: 'Very Beautiful Earrings' } }

      it { is_expected.to eq('Very Beautiful Earrings') }
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

      it "returns the correct volume" do
        expect(subject).to eq(Measured::Volume(0, :ml))
      end
    end
  end

  describe "#density" do
    subject { described_class.new(**args).density.value.to_f }

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

      it { is_expected.to eq(Float::INFINITY) }
    end
  end

  describe "#weight" do
    subject { described_class.new(**args).weight }

    context "with no weight given" do
      let(:args) { {} }
      it { is_expected.to eq(Measured::Weight(0, :g)) }
    end

    context "with a weight" do
      let(:args) { { weight: Measured::Weight(1, :lb) } }
      it { is_expected.to eq(Measured::Weight(453.59237, :g)) }
    end
  end

  describe '#properties' do
    let(:args) { { properties: { flammable: true } } }

    subject { item.properties }

    it { is_expected.to eq(flammable: true) }
  end

  describe 'properties methods' do
    context 'if method is a property' do
      let(:item) do
        FactoryBot.build(:physical_item, properties: { already_packaged: true })
      end

      it 'returns its value' do
        expect(item.already_packaged).to be(true)
      end

      it 'responds to method' do
        expect(item.respond_to?(:already_packaged)).to be(true)
      end
    end

    context 'if method is a string property' do
      let(:item) do
        FactoryBot.build(:physical_item, properties: { 'already_packaged' => true })
      end

      it 'returns its value' do
        expect(item.already_packaged).to be(true)
      end

      it 'responds to method' do
        expect(item.respond_to?(:already_packaged)).to be(true)
      end
    end

    context 'if method is a boolean property' do
      let(:item) do
        FactoryBot.build(:physical_item, properties: { already_packaged: true })
      end

      it 'it is also accessible by its predicate method' do
        expect(item.already_packaged?).to be(true)
      end

      it 'it also responds to its predicate method' do
        expect(item.respond_to?(:already_packaged?)).to be(true)
      end

      context 'with a falsey value' do
        let(:item) do
          FactoryBot.build(:physical_item, properties: { already_packaged: false })
        end

        it 'returns its value' do
          expect(item.already_packaged).to be(false)
        end
      end
    end

    context 'if method is not a property' do
      let(:item) do
        FactoryBot.build(:physical_item, properties: {})
      end

      it 'raises method missing' do
        expect { item.already_packaged? }.to raise_error(NoMethodError)
      end

      it 'does not respond to method' do
        expect(item.respond_to?(:already_packaged?)).to be(false)
      end
    end
  end

  describe 'factory' do
    subject { FactoryBot.build(:physical_item) }

    it 'has coherent attributes' do
      expect(subject.dimensions.map(&:value)).to eq([1, 2, 3])
      expect(subject.weight.value).to eq(50)
    end
  end
end
