# frozen_string_literal: true

RSpec.describe Physical::Item do
  subject(:item) { described_class.new(**args) }

  it_behaves_like 'a cuboid' do
    let(:default_length) { 0 }
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

  describe 'factory' do
    subject { FactoryBot.build(:physical_item) }

    it 'has coherent attributes' do
      expect(subject.dimensions.map(&:value)).to eq([1, 2, 3])
      expect(subject.weight.value).to eq(50)
    end
  end
end
