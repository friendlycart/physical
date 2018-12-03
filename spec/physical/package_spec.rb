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
end
