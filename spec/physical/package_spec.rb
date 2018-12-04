# frozen_string_literal: true

RSpec.describe Physical::Package do
  subject(:package) { described_class.new(args) }

  context 'with no args given' do
    let(:args) { {} }

    it "has no items" do
      expect(subject.items).to be_empty
    end

    it "is an infitely large box" do
      expect(subject.container).to be_a(Physical::Box)
      expect(subject.container.dimensions).to eq(
        [Measured::Length.new(BigDecimal::INFINITY, :cm)] * 3
      )
    end
  end

  describe "#items" do
    let(:args) { {} }

    subject { package.items }

    it { is_expected.to be_empty }
  end

  describe "#<<" do
    let(:args) { {} }
    let(:item) { Physical::Item.new(dimensions: [2, 2, 2]) }

    subject { package.items }

    before do
      package << item
    end

    it { is_expected.to contain_exactly(item) }

    context 'with an item already present' do
      let(:args) { {items: [item]} }

      before do
        package << item
      end

      it { is_expected.to contain_exactly(item) }
    end
  end

  describe "#>>" do
    let(:args) { {items: [item]} }
    let(:item) { Physical::Item.new(dimensions: [2, 2, 2]) }

    subject { package.items }

    before do
      package >> item
    end

    it { is_expected.to be_empty }
  end

  describe "#weight" do
    let(:args) do
      {
        container: Physical::Box.new(weight: 0.8, weight_unit: :lb),
        items: [
          Physical::Item.new(weight: 0.2, weight_unit: :lb),
          Physical::Item.new(weight: 1, weight_unit: :lb)
        ]
      }
    end

    subject { package.weight }

    it "adds the weight of the container with that of the items" do
      expect(subject).to eq(Measured::Weight(2, :lb))
    end
  end

  describe "#remaining_volume" do
    let(:args) do
      {
        container: Physical::Box.new(dimensions: [1, 2, 3]),
        items: Physical::Item.new(dimensions: [1, 1, 1])
      }
    end

    subject { package.remaining_volume }

    it { is_expected.to eq(Measured::Volume(5, :ml)) }
  end

  describe "#id" do
    subject { package.id }

    context "id is given" do
      let(:args) { {id: "12345"} }

      it { is_expected.to eq("12345") }
    end

    context "no ID is given" do
      let(:args) { {} }

      it { is_expected.to be_present }
    end
  end

  describe 'factory' do
    subject { FactoryBot.build(:physical_package) }

    it 'has plausible attributes' do
      expect(subject.weight).to eq(Measured::Weight(1399.88, :g))
    end
  end
end
