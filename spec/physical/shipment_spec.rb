# frozen_string_literal: true

RSpec.describe Physical::Shipment do
  let(:args) { {} }
  subject(:shipment) { described_class.new(args) }

  describe '#packages' do
    subject { shipment.packages }

    it { is_expected.to eq([]) }
  end

  describe '#shipping_method' do
    subject { shipment.shipping_method }

    it { is_expected.to be_nil }
  end

  describe '#origin' do
    subject { shipment.origin }

    it { is_expected.to be_nil }
  end

  describe '#destination' do
    subject { shipment.destination }

    it { is_expected.to be_nil }
  end

  describe '#options' do
    subject { shipment.options }

    it { is_expected.to eq({}) }
  end
end
