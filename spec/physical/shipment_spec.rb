# frozen_string_literal: true

RSpec.describe Physical::Shipment do
  let(:args) { {} }
  subject(:shipment) { described_class.new(**args) }

  describe '#structures' do
    subject { shipment.structures }

    it { is_expected.to eq([]) }
  end

  describe '#packages' do
    subject { shipment.packages }

    it { is_expected.to eq([]) }
  end

  describe '#service_code' do
    subject { shipment.service_code }

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

  describe '#packages' do
    subject { shipment.packages }

    let(:args) { { packages: packages } }
    let(:packages) { [Physical::Package.new(id: "1"), Physical::Package.new(id: "2")] }

    it { is_expected.to eq(packages) }
  end

  describe "factory" do
    subject { FactoryBot.build(:physical_shipment) }

    it "works" do
      expect(subject.origin).to be_a(Physical::Location)
      expect(subject.destination).to be_a(Physical::Location)
      expect(subject.structures).to be_empty
      expect(subject.packages.length).to eq(2)
      expect(subject.service_code).to eq("usps_priority_mail")
    end

    describe "freight" do
      subject { FactoryBot.build(:physical_shipment, :freight) }

      it "works" do
        expect(subject.origin).to be_a(Physical::Location)
        expect(subject.destination).to be_a(Physical::Location)
        expect(subject.structures.length).to eq(1)
        expect(subject.packages.length).to eq(2)
        expect(subject.service_code).to eq("tforce_freight")
      end
    end
  end
end
