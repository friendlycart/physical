# frozen_string_literal: true

RSpec.shared_examples 'a cuboid' do
  let(:args) do
    {
      dimensions: [
        Measured::Length.new(1.1, :cm),
        Measured::Length.new(3.3, :cm),
        Measured::Length.new(2.2, :cm)
      ]
    }
  end

  it { is_expected.to be_a(Physical::Cuboid) }

  it "has dimensions as Measured::Length objects with rational values" do
    expect(subject.dimensions).to eq(
      [
        Measured::Length.new(1.1, :cm),
        Measured::Length.new(3.3, :cm),
        Measured::Length.new(2.2, :cm)
      ]
    )
  end

  it "has getter methods for each dimension as Measured::Length object" do
    expect(subject.length).to eq(Measured::Length.new(1.1, :cm))
    expect(subject.width).to eq(Measured::Length.new(3.3, :cm))
    expect(subject.height).to eq(Measured::Length.new(2.2, :cm))
  end
  
  describe "#==" do
    let(:args) { Hash[id: 123] }
    let(:other_cuboid) { described_class.new(**args) }
    let(:non_cuboid) { double(id: 123) }
    
    it "compares cuboids" do
      aggregate_failures do
        expect(subject == other_cuboid).to be(true)
        expect(subject == non_cuboid).to be(false)
        expect(subject == nil).to be(false)
      end
    end
  end
end
