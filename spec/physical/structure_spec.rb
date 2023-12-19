# frozen_string_literal: true

RSpec.describe Physical::Structure do
  subject(:structure) { described_class.new(**args) }

  context 'with no args given' do
    let(:args) { {} }

    it "has no packages" do
      expect(subject.packages).to be_empty
    end

    it "is an infitely large pallet" do
      expect(subject.container).to be_a(Physical::Pallet)
      expect(subject.dimensions).to eq(
        [Measured::Length.new(BigDecimal::INFINITY, :cm)] * 3
      )
    end
  end

  describe "#packages" do
    let(:args) { {} }

    subject { structure.packages }

    it { is_expected.to be_empty }
  end

  describe "#<<" do
    let(:args) { {} }
    let(:package) { Physical::Package.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) }) }

    subject { structure.packages }

    before do
      structure << package
    end

    it { is_expected.to contain_exactly(package) }

    context 'with a package already present' do
      let(:args) { { packages: [package] } }

      before do
        structure << package
      end

      it { is_expected.to contain_exactly(package) }
    end
  end

  describe "#add" do
    let(:args) { {} }
    let(:package) { Physical::Package.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) }) }

    subject { structure.packages }

    before do
      structure.add(package)
    end

    it { is_expected.to contain_exactly(package) }

    context 'with a package already present' do
      let(:args) { { packages: [package] } }

      before do
        structure.add(package)
      end

      it { is_expected.to contain_exactly(package) }
    end
  end

  describe "#>>" do
    let(:args) { { packages: [package] } }
    let(:package) { Physical::Package.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) }) }

    subject { structure.packages }

    before do
      structure >> package
    end

    it { is_expected.to be_empty }
  end

  describe "#delete" do
    let(:args) { { packages: [package] } }
    let(:package) { Physical::Package.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) }) }

    subject { structure.packages }

    before do
      structure.delete(package)
    end

    it { is_expected.to be_empty }
  end

  describe "#weight" do
    let(:args) do
      {
        container: Physical::Pallet.new(weight: Measured::Weight(0.8, :lb)),
        packages: [
          Physical::Package.new(weight: Measured::Weight(0.2, :lb)),
          Physical::Package.new(weight: Measured::Weight(1, :lb))
        ]
      }
    end

    subject { structure.weight }

    it "adds the weight of the container with that of the packages" do
      expect(subject).to eq(Measured::Weight(2, :lb))
    end

    context 'if no packages given' do
      let(:args) do
        {
          container: Physical::Pallet.new(weight: Measured::Weight(0.8, :lb)),
          packages: []
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
        expect(structure.weight).to eq(Measured::Weight(0.8, :lb))
        expect(structure.length).to eq(Measured::Length(Float::INFINITY, :cm))
        expect(structure.width).to eq(Measured::Length(Float::INFINITY, :cm))
        expect(structure.height).to eq(Measured::Length(Float::INFINITY, :cm))
      end
    end

    context 'with no container given but dimensions given' do
      let(:args) do
        {
          dimensions: [1, 2, 3].map { |d| Measured::Length(d, :cm) },
        }
      end

      it 'keeps that weight and has infinite dimensions' do
        expect(structure.length).to eq(Measured::Length(1, :cm))
        expect(structure.width).to eq(Measured::Length(2, :cm))
        expect(structure.height).to eq(Measured::Length(3, :cm))
        expect(structure.weight).to eq(Measured::Weight(0, :lb))
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
        expect(structure.weight).to eq(Measured::Weight(0.8, :lb))
        expect(structure.length).to eq(Measured::Length(1, :cm))
        expect(structure.width).to eq(Measured::Length(2, :cm))
        expect(structure.height).to eq(Measured::Length(3, :cm))
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
          expect(structure.properties).to eq(foo: :bar)
          expect(structure.container.properties).to eq(foo: :bar)
        end
      end
    end
  end

  describe '#packages_value' do
    subject { structure.packages_value }

    context 'without packages' do
      let(:args) { { packages: [] } }
      it { is_expected.to be_nil }
    end

    context 'without cost defined for packages' do
      let(:args) do
        {
          packages: [
            Physical::Package.new(weight: Measured::Weight(0.2, :lb)),
            Physical::Package.new(weight: Measured::Weight(1, :lb))
          ]
        }
      end
      it { is_expected.to be_nil }
    end

    context 'with cost sparsely defined for packages' do
      let(:args) do
        {
          packages: [
            Physical::Package.new(
              weight: Measured::Weight(0.2, :lb),
              items: [Physical::Item.new(cost: Money.new(12_345, 'USD'))]
            ),
            Physical::Package.new(weight: Measured::Weight(1, :lb))
          ]
        }
      end

      it { is_expected.to be_nil }
    end

    context 'with cost defined for all packages' do
      let(:args) do
        {
          packages: [
            Physical::Package.new(
              weight: Measured::Weight(0.2, :lb),
              items: [Physical::Item.new(cost: Money.new(12_345, 'USD'))]
            ),
            Physical::Package.new(
              weight: Measured::Weight(1, :lb),
              items: [Physical::Item.new(cost: Money.new(12_345, 'USD'))]
            )
          ]
        }
      end

      it { is_expected.to eq(Money.new(24_690, 'USD')) }
    end
  end

  describe "#packages_weight" do
    let(:args) do
      {
        packages: [
          Physical::Package.new(weight: Measured::Weight(0.2, :g)),
          Physical::Package.new(weight: Measured::Weight(1, :g))
        ]
      }
    end

    subject { structure.packages_weight }

    it { is_expected.to eq(Measured::Weight(1.2, :g)) }

    context "after adding packages to the structure" do
      before do
        structure << Physical::Package.new(weight: Measured::Weight(2, :g))
      end

      it { is_expected.to eq(Measured::Weight(3.2, :g)) }
    end

    context "after removing packages from the structure" do
      before do
        structure >> Physical::Package.new(weight: Measured::Weight(1, :g))
      end

      it { is_expected.to eq(Measured::Weight(0.2, :g)) }
    end
  end

  describe 'dimension methods' do
    let(:args) { { container: Physical::Pallet.new(dimensions: [1, 2, 3].map { |d| Measured::Length(d, :cm) }) } }

    it 'forwards them to the container' do
      expect(structure.length).to eq(Measured::Length(1, :cm))
      expect(structure.width).to eq(Measured::Length(2, :cm))
      expect(structure.height).to eq(Measured::Length(3, :cm))
    end
  end

  describe '#volume' do
    let(:args) { { container: Physical::Pallet.new(dimensions: [1, 2, 3].map { |d| Measured::Length(d, :cm) }) } }

    it 'is the container volume' do
      expect(structure.volume).to eq(Measured::Volume(6, :ml))
    end
  end

  describe "#used_volume" do
    let(:args) do
      {
        packages: [
          Physical::Package.new(dimensions: [1, 1, 1].map { |d| Measured::Length(d, :cm) }),
          Physical::Package.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) })
        ]
      }
    end

    subject { structure.used_volume }

    it { is_expected.to eq(Measured::Volume(9, :ml)) }

    context "after adding packages to the structure" do
      before do
        structure << Physical::Package.new(dimensions: [3, 3, 3].map { |d| Measured::Length(d, :cm) })
      end

      it { is_expected.to eq(Measured::Volume(36, :ml)) }
    end

    context "after removing packages from the structure" do
      before do
        structure >> Physical::Package.new(dimensions: [2, 2, 2].map { |d| Measured::Length(d, :cm) })
      end

      it { is_expected.to eq(Measured::Volume(1, :ml)) }
    end
  end

  describe "#remaining_volume" do
    let(:args) do
      {
        container: Physical::Pallet.new(dimensions: [1, 2, 3].map { |d| Measured::Length(d, :cm) }),
        packages: Physical::Package.new(dimensions: [1, 1, 1].map { |d| Measured::Length(d, :cm) })
      }
    end

    subject { structure.remaining_volume }

    it { is_expected.to eq(Measured::Volume(5, :ml)) }
  end

  describe "#id" do
    subject { structure.id }

    context "id is given" do
      let(:args) { { id: "12345" } }

      it { is_expected.to eq("12345") }
    end

    context "no ID is given" do
      let(:args) { {} }

      it { is_expected.to be_present }
    end
  end

  describe 'factory' do
    subject { FactoryBot.build(:physical_structure) }

    it 'has plausible attributes' do
      expect(subject.weight).to eq(Measured::Weight(22.55404, :kg))
    end
  end

  describe "#density" do
    subject { described_class.new(**args).density.value.to_f }

    let(:args) do
      {
        container: Physical::Pallet.new(
          dimensions: dimensions
        ),
        packages: [
          Physical::Package.new(
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

      context "if packages weight is 1" do
        let(:weight) { Measured::Weight(1, :pound) }

        it "returns the density in gramms per cubiq centimeter (ml)" do
          is_expected.to eq(3.7445758536530196)
        end
      end

      context "if packages weight is 0" do
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
