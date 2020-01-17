# frozen_string_literal: true

RSpec.describe Physical::Location do
  let(:args) { {} }

  subject(:location) { described_class.new(**args) }

  it { is_expected.to respond_to(:country) }
  it { is_expected.to respond_to(:zip) }
  it { is_expected.to respond_to(:region) }
  it { is_expected.to respond_to(:city) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:address1) }
  it { is_expected.to respond_to(:address2) }
  it { is_expected.to respond_to(:address3) }
  it { is_expected.to respond_to(:phone) }
  it { is_expected.to respond_to(:fax) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:address_type) }
  it { is_expected.to respond_to(:company_name) }
  it { is_expected.to respond_to(:latitude) }
  it { is_expected.to respond_to(:longitude) }

  describe '#country' do
    subject { location.country }

    it { is_expected.to be_nil }

    context 'with a Carmen::Country given' do
      let(:country) { Carmen::Country.coded('us') }
      let(:args) { { country: country } }

      it { is_expected.to eq(country) }
    end

    context 'with a country code given' do
      let(:country) { :us }
      let(:args) { { country: country } }

      it { is_expected.to eq(Carmen::Country.coded('us')) }
    end
  end

  describe '#subregion' do
    let(:country) { Carmen::Country.coded('us') }
    let(:subregion) { country.subregions.coded('il') }

    subject { location.region }

    context 'with no country given' do
      let(:args) { {} }

      it { is_expected.to be_nil }

      context 'but a subregion given' do
        let(:args) { { region: subregion } }

        it { is_expected.to eq(subregion) }
      end
    end

    context 'with a Carmen::Country given' do
      let(:args) { { country: country } }

      it { is_expected.to be_nil }

      context 'with a region code given' do
        let(:args) { { country: country, region: :il } }

        it { is_expected.to eq(subregion) }
      end
    end

    context 'with a country code given' do
      let(:args) { { country: "US" } }

      it { is_expected.to be_nil }

      context 'with a region code given' do
        let(:args) { { country: "US", region: :il } }

        it { is_expected.to eq(subregion) }
      end
    end
  end

  describe "==" do
    let(:other_location) { described_class.new(**args) }
    let(:non_location) { double(to_hash: location.to_hash) }

    it "compares locations" do
      aggregate_failures do
        expect(location == other_location).to be(true)
        expect(location == non_location).to be(false)
        expect(location.nil?).to be(false)
      end
    end
  end

  describe 'factory' do
    let(:country) { Carmen::Country.coded('us') }
    let(:subregion) { country.subregions.coded('il') }

    subject { FactoryBot.build(:physical_location) }

    it "has coherent attributes" do
      expect(subject.country).to eq(country)
      expect(subject.region).to eq(subregion)
      expect(subject.name).to eq("Jane Doe")
      expect(subject.address1).to eq("11 Lovely Street")
      expect(subject.address2).to eq("South")
      expect(subject.address3).to be_nil
      expect(subject.city).to eq("Herndon")
      expect(subject.company_name).to eq("Company")
    end
  end

  describe 'to_hash' do
    subject { location.to_hash }
    let(:location) { FactoryBot.build(:physical_location) }

    it do
      is_expected.to match(
        hash_including(
          region: 'IL'
        )
      )
    end
  end
end
