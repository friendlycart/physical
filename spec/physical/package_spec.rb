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
      expect(subject.dimensions).to eq(
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
    let(:item) { Physical::Item.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) }) }

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

  describe "#add" do
    let(:args) { {} }
    let(:item) { Physical::Item.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) }) }

    subject { package.items }

    before do
      package.add(item)
    end

    it { is_expected.to contain_exactly(item) }

    context 'with an item already present' do
      let(:args) { {items: [item]} }

      before do
        package.add(item)
      end

      it { is_expected.to contain_exactly(item) }
    end
  end

  describe "#>>" do
    let(:args) { {items: [item]} }
    let(:item) { Physical::Item.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) }) }

    subject { package.items }

    before do
      package >> item
    end

    it { is_expected.to be_empty }
  end

  describe "#delete" do
    let(:args) { {items: [item]} }
    let(:item) { Physical::Item.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) }) }

    subject { package.items }

    before do
      package.delete(item)
    end

    it { is_expected.to be_empty }
  end

  describe "#weight" do
    let(:args) do
      {
        container: Physical::Box.new(weight: Measured::Weight(0.8, :lb)),
        items: [
          Physical::Item.new(weight: Measured::Weight(0.2, :lb)),
          Physical::Item.new(weight: Measured::Weight(1, :lb))
        ]
      }
    end

    subject { package.weight }

    it "adds the weight of the container with that of the items" do
      expect(subject).to eq(Measured::Weight(2, :lb))
    end

    context 'if no items given' do
      let(:args) do
        {
          container: Physical::Box.new(weight: Measured::Weight(0.8, :lb)),
          items: []
        }
      end

      it "does not blow up" do
        expect(subject).to eq(Measured::Weight(0.8, :lb))
      end
    end

    context 'with no container given but weight given' do
      let(:args) do
        {
          weight: Measured::Weight(0.8, :lb),
        }
      end

      it 'keeps that weight and has infinite dimensions' do
        expect(package.weight).to eq(Measured::Weight(0.8, :lb))
        expect(package.length).to eq(Measured::Length(Float::INFINITY, :cm))
        expect(package.width).to eq(Measured::Length(Float::INFINITY, :cm))
        expect(package.height).to eq(Measured::Length(Float::INFINITY, :cm))
      end
    end

    context 'with no container given but dimensions given' do
      let(:args) do
        {
          dimensions: [1, 2, 3].map { |d| Measured::Length(d, :cm) },
        }
      end

      it 'keeps that weight and has infinite dimensions' do
        expect(package.length).to eq(Measured::Length(1, :cm))
        expect(package.width).to eq(Measured::Length(2, :cm))
        expect(package.height).to eq(Measured::Length(3, :cm))
        expect(package.weight).to eq(Measured::Weight(0, :lb))
      end
    end

    context 'with no container given but dimensions and weight given' do
      let(:args) do
        {
          weight: Measured::Weight(0.8, :lb),
          dimensions: [1, 2, 3].map { |d| Measured::Length(d, :cm) },
        }
      end

      it 'keeps that weight and has infinite dimensions' do
        expect(package.weight).to eq(Measured::Weight(0.8, :lb))
        expect(package.length).to eq(Measured::Length(1, :cm))
        expect(package.width).to eq(Measured::Length(2, :cm))
        expect(package.height).to eq(Measured::Length(3, :cm))
      end
    end

    context 'with properties directly given' do
      let(:args) do
        {
          properties: { foo: :bar }
        }
      end

      it 'stores the properties on the container' do
        aggregate_failures do
          expect(package.properties).to eq({foo: :bar})
          expect(package.container.properties).to eq(foo: :bar)
        end
      end
    end
  end

  describe 'dimension methods' do
    let(:args) { { container: Physical::Box.new(dimensions: [1,2,3].map { |d| Measured::Length(d, :cm)}) } }

    it 'forwards them to the container' do
      expect(package.length).to eq(Measured::Length(1, :cm))
      expect(package.width).to eq(Measured::Length(2, :cm))
      expect(package.height).to eq(Measured::Length(3, :cm))
    end
  end

  describe "#remaining_volume" do
    let(:args) do
      {
        container: Physical::Box.new(dimensions: [1, 2, 3].map { |d| Measured::Length(d, :cm) }),
        items: Physical::Item.new(dimensions: [1, 1, 1].map { |d| Measured::Length(d, :cm) })
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
      expect(subject.weight).to eq(Measured::Weight(277.02, :g))
    end
  end

  describe '#void_fill_weight' do
    subject { package.void_fill_weight }

    context 'when void fill density is given' do
      let(:container) do
        Physical::Box.new(
          dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) },
          inner_dimensions: [1, 1, 1].map { |d| Measured::Length(d, :cm) }
        )
      end

      let(:args) { {container: container, void_fill_density: Measured::Weight.new(7, :mg)} }

      it 'calculates the void fill weight from inner dimensions' do
        is_expected.to be_a(Measured::Weight)
        expect(subject.convert_to(:g).value.to_f).to eq(0.007)
      end
    end
  end

  describe "#density" do
    subject { described_class.new(args).density.value.to_f }

    let(:args) do
      {
        container: Physical::Box.new(
          dimensions: dimensions
        ),
        items: [
          Physical::Item.new(
            dimensions: [1, 1, 1].map { |d| Measured::Length(d, :cm) },
            weight: weight
          )
        ]
      }
    end

    context "if container volume is larger than 0" do
      let(:dimensions) do
        [1.1, 2.1, 3.2].map { |d| Measured::Length(d, :in) }
      end

      context "if items weight is 1" do
        let(:weight) { Measured::Weight(1, :pound) }

        it "returns the density in gramms per cubiq centimeter (ml)" do
          is_expected.to eq(3.7445758536530196)
        end
      end

      context "if items weight is 0" do
        let(:weight) { Measured::Weight(0, :pound) }

        it { is_expected.to eq(0.0) }
      end
    end

    context "if container volume is 0" do
      let(:dimensions) do
        [0, 0, 0].map { |d| Measured::Length(d, :in) }
      end

      let(:weight) { Measured::Weight(1, :pound) }

      it { is_expected.to eq(Float::INFINITY) }
    end

    context "if container volume is infinite" do
      let(:dimensions) do
        [1, 2].map { |d| Measured::Length(d, :in) }
      end

      let(:weight) { Measured::Weight(1, :pound) }

      it { is_expected.to eq(0.0) }
    end
  end
end
